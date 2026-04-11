import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/khachhang/danhgia_screen.dart';
import 'package:hotel_booking_app/screens/khachhang/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// Các import từ dự án
import '../../models/datphong_model.dart';
import '../../services/datphong_service.dart';
import '../../services/thanhtoan_service.dart' as tt;
import '../../core/widgets/custom_button.dart';
import '../../widgets/hotelCard.dart';
import '../../services/thongbao_service.dart';
import '../khachhang/trangchu/trangchu_screen.dart';

//================== GIẢ LẬP DỮ  LIỆU ĐỂ CHẠY DEMO ========================( Phần này sẽ được viết trong datphong_service khi xử lý thật )
import '../../models/datphong_model.dart';

class DatPhongService {
  Future<DatPhong> getMockBooking() async {
    await Future.delayed(Duration(seconds: 1)); // giả lập gọi API

    return DatPhong(
      maDatPhong: 1,
      maTaiKhoan: 101,
      maLoaiPhong: 5,
      ngayNhan: DateTime(2026, 4, 10),
      ngayTra: DateTime(2026, 4, 12),
      soKhach: 2,
      soPhongDat: 1,
      tongTien: 1200000,
      maDon: "DH001",
      trangThai: "CHO_XAC_NHAN",
      ngayTao: DateTime.now(),
    );
  }
}
//================== GIẢ LẬP DỮ  LIỆU ĐỂ CHẠY DEMO ========================

class ThanhToanScreen extends StatefulWidget {
  const ThanhToanScreen({super.key});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  DatPhong? booking;
  String qrUrl = "";
  String status = "Đang tải dữ liệu...";
  Timer? timer;

  String _selected = "CHUYEN_KHOAN"; // mặc định chọn chuyển khoản
  bool showQRContent = false; // Mặc định là hiện phần chọn thanh toán
  //thêm biến chặn gọi nhiều lần
  bool _invoiceShown = false;

  // Thông tin QR VietQR
  static const String bankBin = "970418";
  static const String accountNumber = "6801925893";
  static const String accountName = "TRAN THI KIM NGAN";

  @override
  void initState() {
    super.initState();
    loadBooking();
  }

  Future<void> loadBooking() async {
    final data = await DatPhongService().getMockBooking();
    if (!mounted) return;
    setState(() {
      booking = data;
      status = "Nhấn thanh toán";
    });
  }

  String buildQrUrl(int amount, String orderCode) {
    return "https://img.vietqr.io/image/$bankBin-$accountNumber-compact2.png"
        "?amount=$amount&addInfo=$orderCode&accountName=${Uri.encodeComponent(accountName)}";
  }

  void createQR() {
    if (booking == null) return;

    qrUrl = buildQrUrl(booking!.tongTien.toInt(), booking!.maDon);

    if (!mounted) return;

    setState(() {
      status = "⏳ Đang chờ thanh toán...";
      showQRContent = true; // Chuyển sang chế độ hiển thị QR
    });

    startAutoCheck();
  }

  void startAutoCheck() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await checkPayment();
    });
  }

  Future<void> checkPayment() async {
    if (booking == null) return;

    // Khi chạy thật thì sửa hàm kiểm tra này
    //bool success = await tt.kiemTraThanhToan(booking!.maDon, booking!.tongTien);
    bool success = await tt.kiemTraThanhToanDemo();

    if (!mounted) return;

    if (success) {
      setState(() {
        status = "Thanh toán thành công!";
        booking!.trangThai = "DA_THANH_TOAN";
      });

      // GỬI THÔNG BÁO TẠI ĐÂY
      BookingNotificationHelper.notifyBookingSuccess(booking!.maDon);

      timer?.cancel();

      if (!_invoiceShown) {
        _invoiceShown = true;

        Future.delayed(Duration(milliseconds: 300), () {
          if (!mounted) return;

          // Hiển thị hóa đơn PDF
          createInvoicePdf();
          // Sau khi xem xong thì quay về trang chủ
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false,
            );
          }
        });
      }
    } else {
      setState(() {
        status = "⏳ Chưa thấy thanh toán, đang chờ...";
      });
    }
  }

  // Hàm lưu ảnh QR vào thư viện
  // Future<void> saveQRImage() async {
  //   try {
  //     final response = await http.get(Uri.parse(qrUrl));
  //     final result = await ImageGallerySaver.saveImage(response.bodyBytes);

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Đã lưu QR vào thư viện")));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Hàm hiển thị hóa đơn
  Future<void> createInvoicePdf() async {
    final pdf = pw.Document();

    // 1. Tải Font chữ hỗ trợ Tiếng Việt (Rất quan trọng để không bị lỗi ô vuông)
    final fontData = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    // 2. Tạo một TextStyle dùng chung để đỡ phải viết lại nhiều lần
    final baseTextStyle = pw.TextStyle(font: fontData, fontSize: 12);
    final boldTextStyle = pw.TextStyle(font: fontBold, fontSize: 12);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // HEADER: Tên khách sạn & Tiêu đề
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "HOTEL BOOKING APP",
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 18,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.Text(
                      "Địa chỉ: 123 Đường ABC, TP. Hồ Chí Minh",
                      style: pw.TextStyle(font: fontData, fontSize: 10),
                    ),
                    pw.Text(
                      "Hotline: 1900 1234",
                      style: pw.TextStyle(font: fontData, fontSize: 10),
                    ),
                  ],
                ),
                pw.Text(
                  "HÓA ĐƠN",
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 30,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),

            pw.Divider(thickness: 2, color: PdfColors.blue900),
            pw.SizedBox(height: 20),

            // THÔNG TIN KHÁCH HÀNG
            pw.Text(
              "THÔNG TIN KHÁCH HÀNG",
              style: pw.TextStyle(font: fontBold, fontSize: 14),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              "Mã đơn hàng: ${booking!.maDon}",
              style: pw.TextStyle(font: fontData),
            ),
            pw.Text(
              "Ngày thanh toán: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              style: pw.TextStyle(font: fontData),
            ),

            pw.SizedBox(height: 20),

            // BẢNG CHI TIẾT DỊCH VỤ
            pw.TableHelper.fromTextArray(
              border: null,
              headerStyle: boldTextStyle,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
              },
              headerCellDecoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              cellStyle: baseTextStyle,
              headers: ['Mô tả dịch vụ', 'Thành tiền'],
              data: [
                [
                  'Tiền phòng (Đặt phòng ${booking!.maDon})',
                  '${booking!.tongTien} VND',
                ],
                ['Thuế VAT (0%)', '0 VND'],
              ],
            ),

            pw.Divider(),

            // TỔNG TIỀN
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Tổng cộng: ${booking!.tongTien} VND",
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 16,
                        color: PdfColors.red900,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "Trạng thái: ĐÃ THANH TOÁN",
                      style: pw.TextStyle(
                        font: fontBold,
                        color: PdfColors.green700,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.Spacer(), // Đẩy Footer xuống cuối trang
            // FOOTER
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "Cảm ơn quý khách đã tin tưởng và sử dụng dịch vụ!",
                    style: pw.TextStyle(
                      font: fontData,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                  pw.Text(
                    "Đây là hóa đơn điện tử tự động.",
                    style: pw.TextStyle(font: fontData, fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Xem/In PDF
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  void showInvoice() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hóa đơn"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Mã đơn: ${booking!.maDon}"),
            Text("Số tiền: ${booking!.tongTien} VND"),
            Text("Trạng thái: Đã thanh toán"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                // Khi thoát hóa đơn thì chuyển sang màn hình trang chủ
                MaterialPageRoute(builder: (context) => RatingScreen()),
              );
            },
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (booking == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Hoàn tất thanh toán của bạn",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: showQRContent ? _buildQRLayout() : _buildThanhToanLayout(),
      ),
    );
  }

  // Giao diện hiển thị mã QR và trạng thái thanh toán
  Widget _buildQRLayout() {
    return Center(
      // Bọc Center ngoài cùng
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
        crossAxisAlignment:
            CrossAxisAlignment.center, //  Căn giữa theo chiều ngang
        children: [
          const Text(
            "Quét mã để thanh toán",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Dùng Container bọc ảnh để kiểm soát kích thước tốt hơn
          Container(
            alignment: Alignment.center,
            child: Image.network(qrUrl, width: 280),
          ),

          const SizedBox(height: 20),
          Text(
            "Số tiền: ${booking!.tongTien} VND",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(status, style: const TextStyle(color: Colors.blue)),
          const SizedBox(height: 30),

          // Nút lưu QR vào thư viện
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     foregroundColor: const Color(0xFF0077FF),
          //     side: const BorderSide(color: Colors.white),
          //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   onPressed: saveQRImage,
          //   child: Text(
          //     "Lưu mã QR",
          //     style: TextStyle(color: Color(0xFF0077FF)),
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Hướng dẫn thanh toán QR: \nChụp màn hình sau đó mở ví điện tử hoặc Ứng dụng ngân hàng di động có hỗ trợ thanh toán QR bằng VietQR",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // Căn giữa nút bấm
          SizedBox(
            width: double
                .infinity, // Hoặc dùng double.infinity nếu muốn nút dài ra
            child: CustomButton(
              text: "Quay lại chọn phương thức khác",
              onPressed: () => setState(() {
                showQRContent = false;
                qrUrl = ""; // reset QR
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Giao diện hiển thị chọn phương thức thanh toán
  Widget _buildThanhToanLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mã đặt phòng: ${booking!.maDon}",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          buildHotelCard(),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Phương thức thanh toán",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      value: "CHUYEN_KHOAN",
                      groupValue: _selected,
                      onChanged: (val) => setState(() => _selected = val!),
                      title: const Text(
                        "VietQR - Chuyển khoản",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        "Đảm bảo bạn có ví điện tử hoặc ứng dụng ngân hàng tự động hỗ trợ thanh toán bằng VietQR",
                        style: TextStyle(fontSize: 12),
                      ),
                      activeColor: Colors.green,
                    ),
                    RadioListTile<String>(
                      value: "TRUC_TIEP",
                      groupValue: _selected,
                      onChanged: (val) => setState(() => _selected = val!),
                      title: const Text(
                        "Trả tại quầy",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        "Thanh toán khi đến nhận phòng tại khách sạn, vui lòng mang theo giấy tờ tùy thân để nhân viên hỗ trợ",
                        style: TextStyle(fontSize: 12),
                      ),
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Hiển thị lưu ý nếu chọn trả tại quầy
          if (_selected == "TRUC_TIEP")
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Hệ thống sẽ giữ phòng cho bạn đến 18:00 ngày nhận phòng. Vui lòng thanh toán tại quầy lễ tân.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          // Khối tổng tiền và nút thanh toán
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tổng giá tiền: ${booking!.tongTien} VND",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: _selected == "TRUC_TIEP"
                        ? "Xác nhận đặt phòng"
                        : "Hiển thị mã QR",
                    color: _selected == "TRUC_TIEP"
                        ? Colors.green
                        : Colors.deepOrange,
                    onPressed: () {
                      if (_selected == "TRUC_TIEP") {
                        handleBookingAtCounter();
                      } else {
                        createQR();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // if (qrUrl.isNotEmpty)
          //   Column(
          //     children: [
          //       Image.network(qrUrl, width: 250),
          //       const SizedBox(height: 10),
          //       const Text(
          //         "Quét QR bên trên để thanh toán",
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          const SizedBox(height: 20),
          //Text(status),
        ],
      ),
    );
  }

  void handleBookingAtCounter() async {
    // 1. Gọi API/DBService để cập nhật phương thức thanh toán là TRUC_TIEP
    // 2. Gửi thông báo Notification (như bài học trước)
    BookingNotificationHelper.notifyBookingSuccess(booking!.maDon);

    // 3. Hiển thị thông báo thành công
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đặt phòng thành công"),
        content: const Text(
          "Yêu cầu của bạn đã được gửi. Vui lòng kiểm tra thông báo và mang theo CCCD khi đến nhận phòng.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              // Điều hướng về trang chủ hoặc danh sách đơn hàng
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text("Đồng ý"),
          ),
        ],
      ),
    );
  }
}

// Chạy demo kiểm tra thanh toán (luôn trả về true sau 2 giây) và kiểm tra giao diện khi nhấn trả tại quầy
