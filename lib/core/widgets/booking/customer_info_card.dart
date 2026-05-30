import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_review_card_shell.dart';

/// Card hiển thị và cho phép nhập thông tin khách hàng.
///
/// Theo cấu trúc README:
/// - widget chỉ lo UI
/// - controller được truyền từ screen xuống
class CustomerInfoCard extends StatelessWidget {
  final TextEditingController customerNameController;
  final TextEditingController contactInfoController;
  final TextEditingController specialRequestController;

  const CustomerInfoCard({
    super.key,
    required this.customerNameController,
    required this.contactInfoController,
    required this.specialRequestController,
  });

  @override
  Widget build(BuildContext context) {
    return BookingReviewCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin khách hàng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFF2EA8F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: customerNameController,
                      hintText: 'Tên khách hàng',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildTextField(
            controller: contactInfoController,
            hintText: 'Thông tin liên hệ',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  /// Ô nhập dùng lại cho tên, liên hệ, yêu cầu đặc biệt
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      readOnly: true,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF4B5563)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD5D9E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2EA8F4), width: 1.5),
        ),
      ),
    );
  }
}
