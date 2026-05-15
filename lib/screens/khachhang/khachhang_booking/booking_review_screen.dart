import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_info_card.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_review_header.dart';
import 'package:hotel_booking_app/core/widgets/booking/customer_info_card.dart';
import 'package:hotel_booking_app/core/widgets/booking/payment_detail_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_review_data_model.dart';

/// Màn hình hiển thị thông tin đặt trước khi sang thanh toán.
///
/// Màn này:
/// - hiển thị thông tin phòng đã chọn
/// - cho phép nhập / sửa thông tin khách hàng
/// - hiển thị chi tiết phí thanh toán
/// - bấm "Tiếp tục" để đi sang màn thanh toán của thành viên khác
class BookingReviewScreen extends StatefulWidget {
  final BookingReviewDataModel data;

  /// Màn hình thanh toán ở bước tiếp theo.
  ///
  /// Ví dụ khi nối thật:
  /// nextScreenBuilder: (_) => const ThanhToanScreen(),
  final WidgetBuilder? nextScreenBuilder;

  const BookingReviewScreen({
    super.key,
    required this.data,
    this.nextScreenBuilder,
  });

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  late final TextEditingController _customerNameController;
  late final TextEditingController _contactInfoController;
  late final TextEditingController _specialRequestController;

  @override
  void initState() {
    super.initState();

    /// Gán giá trị mặc định từ data truyền sang.
    _customerNameController =
        TextEditingController(text: widget.data.customerName);
    _contactInfoController =
        TextEditingController(text: widget.data.contactInfoText);
    _specialRequestController =
        TextEditingController(text: widget.data.specialRequestText);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _handleContinue() {
    if (!_validateBeforeContinue()) return;

    /// TODO:
    /// Nếu sau này màn thanh toán cần nhận dữ liệu,
    /// bạn có thể truyền tiếp:
    /// - _customerNameController.text
    /// - _contactInfoController.text
    /// - _specialRequestController.text

    if (widget.nextScreenBuilder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: widget.nextScreenBuilder!,
        ),
      );
      return;
    }

    _showMessage('Hãy nối nextScreenBuilder với màn thanh toán của thành viên khác.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Column(
          children: [
            BookingReviewHeader(hotelName: widget.data.hotelName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    BookingInfoCard(data: widget.data),
                    const SizedBox(height: 14),

                    /// Card nhập thông tin khách hàng
                    CustomerInfoCard(
                      loginMethodText: widget.data.loginMethodText,
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
                      backgroundColor: const Color(0xFF2EA8F4),
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