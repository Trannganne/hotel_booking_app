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

  Future<double> getTotalPaymentByBookingId(String bookingId) async {
    await loadPayments();

    return payments
        .where((payment) => payment.bookingId == bookingId)
        .fold<double>(0, (sum, payment) => sum + payment.totalPrice);
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
      //Thêm phần createdAt và paidAt để lưu thời gian tạo và thanh toán
      PaymentModel payment = PaymentModel(
        bookingId: bookingId,
        orderCode: orderCode,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
        paidAt: DateTime.now(),
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

  Future<void> payAndGenerateInvoice(PaymentModel payment) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. kiểm tra thanh toán
      // final isPaid = await _paymentService.kiemTraThanhToan(
      //   payment.orderCode,
      //   payment.totalPrice,
      // );
      final isPaid = await _paymentService.kiemTraThanhToanDemo();

      if (!isPaid) {
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
      });

      await _notificationService.notifyPaymentSuccess(payment.orderCode);

      // 3. Tạo bản sao của hóa đơn với thông tin đã cập nhật để tạo PDF
      final updated = payment.copyWith(status: "PAID", paidAt: DateTime.now());

      // Gọi createInvoicePdf với callback nếu có
      await _paymentService.createInvoicePdf(
        updated,
        onInvoiceShown: onInvoiceShown,
      );

      // Cập nhật UI
      status = "Thanh toán thành công";
      _invoiceShown = true;

      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi pay & invoice: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  //================================= TẠO MÃ QR ====================================
  Future<void> createQR(PaymentModel payment) async {
    qrUrl = _paymentService.buildQrUrl(
      payment.totalPrice.toInt(),
      payment.orderCode,
    );

    status = "⏳ Đang chờ thanh toán...";
    showQRContent = true; // Chuyển sang chế độ hiển thị QR
    notifyListeners();

    startAutoCheck(payment);
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
