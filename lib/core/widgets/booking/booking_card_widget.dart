import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_status_chip.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_status.dart';

/// Card hiển thị 1 đơn đặt phòng trong danh sách booking.
class BookingCardWidget extends StatelessWidget {
  final BookingOrderUiModel booking;
  final VoidCallback onDetailTap;
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
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child:
                      booking.hotelImagePath == null ||
                          booking.hotelImagePath!.isEmpty
                      ? const PlaceholderImageBox(
                          height: 92,
                          label: 'TODO: Thêm ảnh booking trong service',
                        )
                      : Image.asset(booking.hotelImagePath!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                      booking.stayDateText,
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
                      booking.paidTotalText,
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
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetailTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF0077FF),
                    side: const BorderSide(color: Colors.grey),
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
              if (booking.status == BookingStatus.completed) ...<Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReviewTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0077FF),
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
