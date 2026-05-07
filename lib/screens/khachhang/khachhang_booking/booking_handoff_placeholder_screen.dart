import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';

/// Màn placeholder để bàn giao sang phần của thành viên khác.
class BookingHandoffPlaceholderScreen extends StatelessWidget {
  final String titleText;
  final String description;

  const BookingHandoffPlaceholderScreen({
    super.key,
    required this.titleText,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldShell(
      title: titleText,
      body: SingleChildScrollView(
        padding: screenPadding,
        child: SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.compare_arrows_rounded,
                size: 56,
                color: BookingColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                titleText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: BookingColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Ghi chú: Sau này chỉ cần thay màn placeholder này bằng màn nhập '
                  'thông tin / thanh toán / đánh giá thật của nhóm là được.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: BookingColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
