import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/services/hotel_service/hotel_service.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

// CÁC GÓI TẠO HÓA ĐƠN
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentService {
  final db = FirestoreService();

  final hotel_db = HotelService();

  // Collection đã gắn converter ( hàm này bắt buộc phải có trong mỗi service)
  CollectionReference<PaymentModel> get _ref =>
      db.colWithConverter<PaymentModel>(
        name: 'payments',
        fromFirestore: (snap, _) =>
            PaymentModel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  //============================ GET ============================
  // Hàm lấy danh sách tất cả payment
  Future<List<PaymentModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  // Hàm lấy 1 payment theo ID
  Future<PaymentModel?> getByID(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }

  // Hàm lấy 1 payment theo ID của booking
  Future<PaymentModel?> getByBookingID(String bookingId) async {
    final snapshot = await _ref.get();

    try {
      return snapshot.docs
          .map((e) => e.data())
          .firstWhere((payment) => payment.bookingId == bookingId);
    } catch (e) {
      return null;
    }
  }
  //============================ CREATE ============================

  // Hàm thêm payment ( Firebase tự tạo ID( mã payment))
  Future<PaymentModel> addPayment(PaymentModel payment) async {
    final docRef = _ref.doc();

    final newPayment = PaymentModel(
      id: docRef.id,
      bookingId: payment.bookingId,
      orderCode: payment.orderCode,
      totalPrice: payment.totalPrice,
      paymentMethod: payment.paymentMethod,
      status: payment.status,
      //Thêm phần createdAt và paidAt để lưu thời gian tạo và thanh toán
      createdAt: payment.createdAt,
      paidAt: payment.paidAt,
    );

    await docRef.set(newPayment);
    return newPayment;
  }

  //============================ UPDATE ============================
  // Hàm update thông tin payment
  Future<void> updatePayment(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  //============================ TẠO ORDERCODE ============================

  String generateOrderCode() {
    final now = DateTime.now();
    final random = Random().nextInt(9999);

    return "BK"
        "${now.year}${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}"
        "${now.hour.toString().padLeft(2, '0')}"
        "${now.minute.toString().padLeft(2, '0')}"
        "${now.second.toString().padLeft(2, '0')}"
        "${random.toString().padLeft(3, '0')}";
  }

  //============================ TẠO QR CODE ============================
  // Thông tin QR VietQR
  static const String bankBin = "970418";
  static const String accountNumber = "96247D3J2P";
  static const String accountName = "TRAN THI KIM NGAN";

  // Tạo QR code URL cho chuyển khoản ngân hàng
  String buildQrUrl(int amount, String orderCode) {
    return "https://img.vietqr.io/image/$bankBin-$accountNumber-compact2.png"
        "?amount=$amount&addInfo=$orderCode&accountName=${Uri.encodeComponent(accountName)}";
  }

  //============================ KIỂM TRA THANH TOÁN ============================

  Future<bool> kiemTraThanhToan(
    String noiDungChuyenKhoan,
    double soTien,
  ) async {
    const Duration timeout = Duration(minutes: 15);
    const Duration interval = Duration(seconds: 60);

    final DateTime thoiGianKetThuc = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(thoiGianKetThuc)) {
      final bool result = await _kiemTraThanhToanMotLan(
        noiDungChuyenKhoan,
        soTien,
      );

      if (result) return true;

      await Future.delayed(interval);
    }

    return false;
  }

  Future<bool> _kiemTraThanhToanMotLan(
    String noiDungChuyenKhoan,
    double soTien,
  ) async {
    const String sepayToken =
        "TERDPG9GUZPZSXBTFBBL3NWQ6CWNGLG8HYXSQIPJKPDVB2HJOHOMYAIRMLAKCLKF";
    const String sepayAccount = "96247D3J2P";

    try {
      final Uri url = Uri.parse(
        "https://my.sepay.vn/userapi/transactions/list"
        "?account_number=$sepayAccount&limit=20",
      );

      final response = await http
          .get(url, headers: {'Authorization': 'Bearer $sepayToken'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transactions = data['transactions'] as List<dynamic>;

        for (var trans in transactions) {
          final content = trans['transaction_content'].toString();
          final amount = double.tryParse(trans['amount_in'].toString()) ?? 0;

          if (content.contains(noiDungChuyenKhoan) && amount >= soTien) {
            return true;
          }
        }
      } else {
        print("Lỗi API Sepay: ${response.statusCode} - ${response.body}");
      }
    } on TimeoutException {
      print("Timeout khi gọi Sepay");
    } catch (e) {
      print("Lỗi khi kiểm tra thanh toán: $e");
    }

    return false;
  }

  // =================== Hàm kiểm tra thanh toán (dành cho demo)

  Future<bool> kiemTraThanhToanDemo() async {
    await Future.delayed(const Duration(seconds: 2)); // Giả lập thời gian chờ

    return true; // Trả về true để giả lập thanh toán thành công
  }

  //============================ STREAM PAYMENT ============================
  // Hàm lắng nghe thay đổi của một payment theo ID (dùng để autom thanh toán)
  Stream<DocumentSnapshot<PaymentModel>> getPaymentStream(String paymentId) {
    return _ref.doc(paymentId).snapshots();
  }

  //============================= Hàm hiển thị hóa đơn
  Future<void> createInvoicePdf(
    PaymentModel payment, {
    VoidCallback? onInvoiceShown,
  }) async {
    final pdf = pw.Document();

    // Lấy địa chỉ thật từ hotel
    final hotel = await hotel_db.getHotel();
    final hotelName = hotel?.hotelName ?? "HOTEL BOOKING APP";
    final hotelAddress = hotel != null
        ? "${hotel.address}, ${hotel.city}"
        : "123 Đường ABC, TP. Hồ Chí Minh";
    final invoiceDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    final formattedTotal = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(payment.totalPrice);

    final invoiceNumber = payment.id ?? payment.orderCode;
    // final currentUser = FirebaseAuth.instance.currentUser;
    // final customerName =
    //     (currentUser?.displayName != null &&
    //         currentUser!.displayName!.trim().isNotEmpty)
    //     ? currentUser.displayName!
    //     : 'Khách hàng';
    // final customerEmail = currentUser?.email ?? 'Không có email';
    // final customerPhone = currentUser?.phoneNumber ?? 'Không có số điện thoại';

    // 1. Tải Font chữ hỗ trợ Tiếng Việt
    final fontData = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final baseTextStyle = pw.TextStyle(
      font: fontData,
      fontSize: 12,
      color: PdfColors.grey900,
    );

    final titleTextStyle = pw.TextStyle(
      font: fontBold,
      fontSize: 20,
      color: PdfColors.blue900,
    );
    final headerTextStyle = pw.TextStyle(
      font: fontBold,
      fontSize: 14,
      color: PdfColors.blue900,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue900, width: 1.5),
                borderRadius: pw.BorderRadius.circular(10),
                color: PdfColors.blue50,
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(hotelName, style: titleTextStyle),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        hotelAddress,
                        style: baseTextStyle.copyWith(fontSize: 10),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Hotline: 1900 1234',
                        style: baseTextStyle.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'HÓA ĐƠN THANH TOÁN',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 18,
                          color: PdfColors.grey900,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Số hóa đơn: $invoiceNumber',
                        style: baseTextStyle,
                      ),
                      pw.Text('Ngày: $invoiceDate', style: baseTextStyle),
                      pw.Text('Trạng thái: ', style: baseTextStyle),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.green100,
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: pw.Text(
                          'ĐÃ THANH TOÁN',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 10,
                            color: PdfColors.green900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Thông tin đơn hàng + khách hàng
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.grey100,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('THÔNG TIN ĐƠN HÀNG', style: headerTextStyle),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Mã đơn đặt phòng: ${payment.orderCode}',
                          style: baseTextStyle,
                        ),
                        pw.Text(
                          'Mã booking: ${payment.bookingId}',
                          style: baseTextStyle,
                        ),
                        pw.Text(
                          'Tổng giá tiền: $formattedTotal',
                          style: baseTextStyle,
                        ),
                        pw.Text(
                          'Phương thức: ${payment.paymentMethod}',
                          style: baseTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 12),
                // pw.Expanded(
                //   flex: 1,
                //   child: pw.Container(
                //     padding: const pw.EdgeInsets.all(12),
                //     decoration: pw.BoxDecoration(
                //       border: pw.Border.all(color: PdfColors.grey300),
                //       borderRadius: pw.BorderRadius.circular(8),
                //       color: PdfColors.grey100,
                //     ),
                //     child: pw.Column(
                //       crossAxisAlignment: pw.CrossAxisAlignment.start,
                //       children: [
                //         pw.Text('THÔNG TIN KHÁCH HÀNG', style: headerTextStyle),
                //         pw.SizedBox(height: 8),
                //         pw.Text('Tên: $customerName', style: baseTextStyle),
                //         pw.Text('Email: $customerEmail', style: baseTextStyle),
                //         pw.Text('SĐT: $customerPhone', style: baseTextStyle),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),

            pw.SizedBox(height: 25),

            // Chi tiết dịch vụ
            pw.Text('CHI TIẾT DỊCH VỤ', style: headerTextStyle),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide(
                  color: PdfColors.grey300,
                  width: 0.5,
                ),
                verticalInside: pw.BorderSide(
                  color: PdfColors.grey300,
                  width: 0.5,
                ),
                top: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                left: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                right: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              headerHeight: 28,
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(
                font: fontBold,
                color: PdfColors.white,
                fontSize: 12,
              ),
              cellStyle: baseTextStyle,
              columnWidths: {
                0: const pw.FlexColumnWidth(4),
                1: const pw.FlexColumnWidth(2),
              },
              headers: ['Mô tả dịch vụ', 'Thành tiền'],
              data: [
                ['Tiền phòng (Đặt phòng ${payment.orderCode})', formattedTotal],
                [
                  'Thuế VAT (0%)',
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: '₫',
                    decimalDigits: 0,
                  ).format(0),
                ],
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
                color: PdfColors.grey100,
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Ghi chú', style: headerTextStyle),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Hóa đơn này là chứng từ thanh toán điện tử.',
                        style: baseTextStyle.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Tổng cộng: ',
                            style: baseTextStyle.copyWith(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            formattedTotal,
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 14,
                              color: PdfColors.red900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.Spacer(),

            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.',
                style: baseTextStyle.copyWith(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Hóa đơn chỉ có giá trị khi không bị tẩy xóa.',
                style: baseTextStyle.copyWith(fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    onInvoiceShown?.call();
  }
}
