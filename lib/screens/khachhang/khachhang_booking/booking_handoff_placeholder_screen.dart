import 'package:flutter/material.dart';

import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';

/// Màn placeholder để handoff sang module khác.
///
/// Dùng tạm trong giai đoạn phần nhập thông tin, thanh toán hoặc đánh giá
/// đang do thành viên khác phụ trách.
class BookingHandoffPlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const BookingHandoffPlaceholderScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldShell(
      title: title,
      bottomNavigationBar: const BookingBottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: screenPadding,
        child: SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: BookingColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: BookingColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
