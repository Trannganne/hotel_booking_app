import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/services/notification_service/thongbao_service.dart';
import 'package:hotel_booking_app/services/payment_service/thanhtoan_service.dart';
import 'package:hotel_booking_app/services/roomType_service/roomType_Service.dart';

class Paymentcontroller extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  final NotificationService _notificationService = NotificationService();
  final RoomTypeService _roomTypeService = RoomTypeService();

  // Lấy thông tin room type để hiển thị trong card
  Future<RoomTypeModel?> getRoomType(String roomTypeId) async {
    return await _roomTypeService.getByID(roomTypeId);
  }

  StreamSubscription? paymentListener;

  Timer? timer;

  bool isLoading = false;
  bool showQRContent = false;
  String status = "Đang tải dữ liệu...";
  String qrUrl = "";
  bool _invoiceShown = false;

  // Callback để xử lý điều hướng sau khi hóa đơn được hiển thị
  VoidCallback? onInvoiceShown;

  List<PaymentModel> payments = [];

  // Lấy payment theo Id

  Future<PaymentModel?> getPaymentByBookingId(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      return await _paymentService.getByBookingID(id);
    } catch (e) {
      debugPrint("Lỗi lấy payment theo booking id: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load tất cả payment

  Future<void> loadPayments() async {
    try {
      isLoading = true;
      notifyListeners();

      payments = await _paymentService.getAll();
    } catch (e) {
      debugPrint("Lỗi load payments: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================= CRUD Payment ============================
  // THÊM MỚI PAYMENT
  Future<PaymentModel?> createPayment(
    String bookingId,
    double totalPrice,
    String paymentMethod,
    String orderCode,
  ) async {
    try {
      // Tạo đối tượng PaymentModel với thông tin cần thiết
      PaymentModel payment = PaymentModel(
        bookingId: bookingId,
        orderCode: orderCode,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
      );
      final result = await _paymentService.addPayment(payment);
      await loadPayments(); // Tải lại danh sách sau khi thêm mới
      return result;
    } catch (e) {
      debugPrint("Lỗi tạo payment: $e");
      return null;
    }
  }

  // CẬp NHẬT PHƯƠNG THỨC THANH TOÁN (khi khách chọn thanh toán trực tiếp tại quầy)
  Future<void> updatePaymentMethod(String paymentId, String newMethod) async {
    try {
      await _paymentService.updatePayment(paymentId, {
        "paymentMethod": newMethod,
      });
      await loadPayments(); // Tải lại danh sách sau khi cập nhật
    } catch (e) {
      debugPrint("Lỗi cập nhật phương thức thanh toán: $e");
    }
  }

  //=================================================================================
  // TẠO ORDERCODE
  String generateOrderCode() {
    final code = _paymentService.generateOrderCode();
    return code;
  }

  // ================= PAY + INVOICE =================

  // Hàm set callback để xử lý sau khi hóa đơn được hiển thị
  void setInvoiceCallback(VoidCallback callback) {
    onInvoiceShown = callback;
  }

  // Hàm mới: Gọi createInvoicePdf với callback để quay về màn hình chính
  Future<void> createInvoicePdfWithCallback(
    PaymentModel payment,
    VoidCallback onInvoiceShown,
  ) async {
    try {
      await _paymentService.createInvoicePdf(
        payment,
        onInvoiceShown: onInvoiceShown,
      );
    } catch (e) {
      debugPrint("Lỗi tạo hóa đơn: $e");
    }
  }

  // Đây nè
  // Flow sau khi chuyển qua sepay thật
  Future<void> payAndGenerateInvoice(PaymentModel payment) async {
    try {
      isLoading = true;
      notifyListeners();

      //1. kiểm tra thanh toán
      final trans = await _paymentService.kiemTraThanhToan(
        payment.orderCode,
        payment.totalPrice,
      );
      //final isPaid = await _paymentService.kiemTraThanhToanDemo();

      if (trans == null) {
        status = "Chưa thanh toán";
        notifyListeners();
        return;
      }

      // Dừng timer
      timer?.cancel();

      if (_invoiceShown) return;

      // 2. cập nhật trạng thái
      await _paymentService.updatePayment(payment.id!, {
        "status": "PAID",
        "paidAt": DateTime.now(),
        "transactionId": trans["id"]?.toString(),
        "transferContent": trans["transaction_content"]?.toString(),
      });

      await _notificationService.notifyPaymentSuccess(payment.orderCode);

      // // 3. Tạo bản sao của hóa đơn với thông tin đã cập nhật để tạo PDF
      // final updated = payment.copyWith(status: "PAID", paidAt: DateTime.now());

      // // Gọi createInvoicePdf với callback nếu có
      // await _paymentService.createInvoicePdf(
      //   updated,
      //   onInvoiceShown: onInvoiceShown,
      // );

      // // Cập nhật UI
      // status = "Thanh toán thành công";
      // _invoiceShown = true;

      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi pay & invoice: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Flow 3
  // KHI KẾT HỢP SEPAY THẬT SẼ GỌI HÀM NÀY THAY VÌ startAutoCheck
  //======== Lắng nghe realtime trạng thái thanh toán từ Firestore.
  void listenPaymentStatus(String paymentId) {
    paymentListener?.cancel();

    paymentListener = _paymentService.getPaymentStream(paymentId).listen((
      snapshot,
    ) async {
      final payment = snapshot.data();

      if (payment == null) return;

      if (payment.status == "PAID" && !_invoiceShown) {
        status = "Thanh toán thành công!";

        await _paymentService.createInvoicePdf(
          payment,
          onInvoiceShown: onInvoiceShown,
        );

        _invoiceShown = true;
        notifyListeners();
      }
    });
  }

  //================================ RESET INVOICE FLAG =================
  void resetInvoiceFlag() {
    _invoiceShown = false;
    notifyListeners();
  }

  // FLow 1
  //================================= TẠO MÃ QR ====================================
  Future<void> createQR(PaymentModel payment) async {
    debugPrint("=== createQR START ===");
    debugPrint("Payment ID: ${payment.id}");
    debugPrint("OrderCode: ${payment.orderCode}");
    try {
      qrUrl = _paymentService.buildQrUrl(
        payment.totalPrice.toInt(),
        payment.orderCode,
      );
      debugPrint("QR URL = $qrUrl");
      status = "⏳ Đang chờ thanh toán...";
      showQRContent = true; // Chuyển sang chế độ hiển thị QR
      notifyListeners();
      listenPaymentStatus(payment.id!);

      await payAndGenerateInvoice(payment);
    } catch (e, stackTrace) {
      debugPrint("Lỗi createQR: $e");
      debugPrintStack(stackTrace: stackTrace);

      status = "Không thể tạo mã QR";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    paymentListener?.cancel();
    super.dispose();
  }

  void startAutoCheck(PaymentModel payment) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await payAndGenerateInvoice(payment);
    });
  }
}
