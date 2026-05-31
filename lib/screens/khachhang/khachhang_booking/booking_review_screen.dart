import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_info_card.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_review_header.dart';
import 'package:hotel_booking_app/core/widgets/booking/customer_info_card.dart';
import 'package:hotel_booking_app/core/widgets/booking/payment_detail_card.dart';
import 'package:hotel_booking_app/models/models_booking_ui/booking_review_data_model.dart';
import 'package:hotel_booking_app/screens/khachhang/payment/paymentScreen.dart';
import 'package:provider/provider.dart';

class BookingPreviewScreen extends StatefulWidget {
  final BookingPreviewModel data;

  /// Màn hình thanh toán ở bước tiếp theo.
  ///
  /// Ví dụ khi nối thật:
  /// nextScreenBuilder: (_) => const ThanhToanScreen(),
  final WidgetBuilder? nextScreenBuilder;

  const BookingPreviewScreen({
    super.key,
    required this.data,
    this.nextScreenBuilder,
  });

  @override
  State<BookingPreviewScreen> createState() => _BookingPreviewScreenState();
}

class _BookingPreviewScreenState extends State<BookingPreviewScreen> {
  late final TextEditingController _customerNameController;
  late final TextEditingController _contactInfoController;
  late final TextEditingController _specialRequestController;

  @override
  void initState() {
    super.initState();

    /// Gán giá trị mặc định từ data truyền sang.
    _customerNameController = TextEditingController(
      text: widget.data.customerName,
    );
    _contactInfoController = TextEditingController(
      text: widget.data.customerPhone,
    );
    _specialRequestController = TextEditingController(
      text: widget.data.customerEmail,
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _contactInfoController.dispose();
    _specialRequestController.dispose();
    super.dispose();
  }

  /// Kiểm tra nhanh trước khi sang bước thanh toán.
  bool _validateBeforeContinue() {
    if (_customerNameController.text.trim().isEmpty) {
      _showMessage('Vui lòng nhập tên khách hàng.');
      return false;
    }

    if (_contactInfoController.text.trim().isEmpty) {
      _showMessage('Vui lòng nhập thông tin liên hệ.');
      return false;
    }

    return true;
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _handleContinue() async {
    if (!_validateBeforeContinue()) return;

    final request = widget.data.bookingRequest;

    // Tạo booking
    final _bookingController = context.read<BookingController>();

    await _bookingController.createBooking(request);

    if (_bookingController.errorMessage == null &&
        _bookingController.lastBooking != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ThanhToanScreen(booking: _bookingController.lastBooking!),
        ),
      );
    } else {
      print("Lỗi tạo booking: ${_bookingController.errorMessage}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Column(
          children: [
            BookingReviewHeader(hotelName: widget.data.roomType.roomTypeName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    BookingInfoCard(data: widget.data),
                    const SizedBox(height: 14),

                    // THông tin người đặt
                    CustomerInfoCard(
                      customerNameController: _customerNameController,
                      contactInfoController: _contactInfoController,
                      specialRequestController: _specialRequestController,
                    ),

                    const SizedBox(height: 14),
                    PaymentDetailCard(data: widget.data),
                  ],
                ),
              ),
            ),

            /// Nút cố định dưới cùng
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Tiếp tục',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
