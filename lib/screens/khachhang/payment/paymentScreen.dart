import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/khachhang/payment/paymentController.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/screens/khachhang/main_screen.dart';
import 'package:hotel_booking_app/widgets/review/RoomBookingCard.dart';
import 'package:hotel_booking_app/widgets/review/format.dart';
import 'package:intl/intl.dart';

// Các import từ dự án
import '../../../core/widgets/custom_button.dart';
import '../../../services/notification_service/thongbao_service.dart';
import 'package:provider/provider.dart';

//================== GIẢ LẬP DỮ  LIỆU ĐỂ CHẠY DEMO ========================

class ThanhToanScreen extends StatefulWidget {
  final BookingModel booking;

  const ThanhToanScreen({super.key, required this.booking});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  final NotificationService _notificationService = NotificationService();
  PaymentModel? payment;

  String _selected = "CHUYEN_KHOAN"; // mặc định chọn chuyển khoản
  bool showQRContent = false; // Mặc định là hiện phần chọn thanh toán
  //thêm biến chặn gọi nhiều lần

  String? orderCode;
  RoomTypeModel? roomType;

  @override
  void initState() {
    super.initState();

    orderCode = context.read<Paymentcontroller>().generateOrderCode();

    loadRoomType();
  }

  Future<void> loadRoomType() async {
    roomType = await context.read<Paymentcontroller>().getRoomType(
      widget.booking.roomTypeId,
    );

    setState(() {});
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

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0077FF),
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
            child: Image.network(
              context.read<Paymentcontroller>().qrUrl,
              width: 280,
            ),
          ),

          const SizedBox(height: 20),
          Text(
            "Số tiền: ${payment!.totalPrice} VND",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.read<Paymentcontroller>().status,
            style: const TextStyle(color: Colors.blue),
          ),
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
                context.read<Paymentcontroller>().qrUrl = ""; // reset QR
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Giao diện hiển thị chọn phương thức thanh toán
  Widget _buildThanhToanLayout() {
    if (roomType == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final imageUrl = roomType!.imagesList.isNotEmpty
        ? roomType!.imagesList.first
        : '';
    final formattedTotal = NumberFormat.decimalPattern(
      'vi_VN',
    ).format((widget.booking.totalPrice ?? 0).round());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mã đặt phòng: $orderCode",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          RoomBookingCard(
            roomName: roomType!.roomTypeName,
            bookingDates:
                "${formatDate(widget.booking.checkIn)} - ${formatDate(widget.booking.checkout)}",
            imageUrl: imageUrl,
          ),
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
                  "Tổng giá tiền: $formattedTotal VND",
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
                    onPressed: () async {
                      // Kiểm tra nếu tổng tiền null thì không tạo payment được
                      if (widget.booking.totalPrice == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Không tìm thấy tổng tiền"),
                          ),
                        );
                        return;
                      }

                      final paymentController = context
                          .read<Paymentcontroller>();

                      final newPayment = await paymentController.createPayment(
                        widget.booking.id!,
                        widget.booking.totalPrice!,
                        _selected,
                        orderCode!,
                      );
                      if (!mounted) return;

                      if (newPayment == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Tạo thanh toán thất bại, vui lòng thử lại sau",
                            ),
                          ),
                        );
                        return;
                      }

                      await _notificationService.notifyBookingSuccess(
                        orderCode!,
                      );
                      if (!mounted) return;

                      setState(() {
                        payment = newPayment;
                      });

                      // Hiện thông báo thành công cho mọi phương thức
                      await _showBookingSuccessDialog();

                      if (!mounted) return;

                      // Nếu trả tại quầy
                      if (_selected == "TRUC_TIEP") {
                        handleBookingAtCounter();
                      } else {
                        // Set callback để quay về MainScreen khi hóa đơn được hiển thị
                        paymentController.setInvoiceCallback(() {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        });

                        await paymentController.createQR(newPayment);
                        if (!mounted) return;

                        setState(() {
                          showQRContent = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          //Text(status),
        ],
      ),
    );
  }

  void handleBookingAtCounter() async {
    if (payment == null) return;
    // 1. Gọi API/DBService để cập nhật phương thức thanh toán là TRUC_TIEP
    final controller = context.read<Paymentcontroller>();

    await controller.updatePaymentMethod(payment!.id!, "TRUC_TIEP");
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
      (route) => false,
    );
  }

  Future<void> _showBookingSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đặt phòng thành công"),
        content: const Text(
          "Yêu cầu đặt phòng của bạn đã được ghi nhận.\n Vui lòng kiểm tra thông báo và mang theo CCCD khi đến nhận phòng.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Đồng ý"),
          ),
        ],
      ),
    );
  }
}
