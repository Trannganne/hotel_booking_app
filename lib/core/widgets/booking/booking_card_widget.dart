import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_status.dart';
import 'booking_constants.dart';
import 'booking_status_chip.dart';
import 'placeholder_image_box.dart';
import 'section_card.dart';

/// Card hiển thị 1 booking trong danh sách lịch đặt phòng.
class BookingCardWidget extends StatelessWidget {
  final BookingOrderUiModel booking;

  /// Callback mở màn chi tiết đơn đặt.
  final VoidCallback onDetailTap;

  /// Callback mở màn đánh giá.
  ///
  /// Chỉ dùng khi booking ở trạng thái hoàn tất.
  final VoidCallback? onReviewTap;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.onDetailTap,
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const SizedBox(
                  width: 92,
                  height: 92,
                  child: PlaceholderImageBox(
                    height: 92,
                    label: 'Ảnh',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.hotelName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'MÃ BOOKING: ${booking.bookingCode}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: BookingColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${booking.checkInDate} - ${booking.checkOutDate}',
                      style: const TextStyle(
                        color: BookingColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BookingStatusChip(status: booking.status),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      booking.totalPriceText,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Khu vực action của card.
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetailTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BookingColors.textPrimary,
                    side: const BorderSide(color: BookingColors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text(
                    'XEM CHI TIẾT',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              if (booking.status == BookingStatus.completed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReviewTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BookingColors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text(
                      'ĐÁNH GIÁ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
