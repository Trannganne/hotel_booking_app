import 'package:flutter/material.dart';

import 'package:hotel_booking_app/services/booking_mock_service.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'booking_history_screen.dart';
import 'hotel_detail_booking_screen.dart';

/// Màn root chỉ dùng để test nhanh toàn bộ flow module đặt phòng.
///
/// Trong project thật, bạn có thể bỏ màn này và điều hướng trực tiếp
/// từ trang chủ chung sang các screen cần thiết.
class BookingCustomerRootScreen extends StatelessWidget {
  const BookingCustomerRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const service = BookingMockService();

    return Scaffold(
      backgroundColor: BookingColors.background,
      appBar: AppBar(
        title: const Text('Demo module đặt phòng'),
        backgroundColor: BookingColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: screenPadding,
        children: [
          const SectionCard(
            child: Text(
              'Màn này chỉ để test nhanh toàn bộ flow của module. Khi ghép vào project thật, bạn có thể gọi trực tiếp từng screen theo nhu cầu.',
              style: TextStyle(
                color: BookingColors.textSecondary,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _MenuButton(
            title: '1. Chi tiết khách sạn + danh sách phòng',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotelDetailBookingScreen(
                    hotelId: 'hotel_1',
                    service: service,
                  ),
                ),
              );
            },
          ),
          _MenuButton(
            title: '2. Lịch đặt phòng',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingHistoryScreen(service: service),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Nút menu dùng lại trong màn demo root.
class _MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: BookingColors.textPrimary,
          elevation: 0,
          side: const BorderSide(color: BookingColors.border),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
