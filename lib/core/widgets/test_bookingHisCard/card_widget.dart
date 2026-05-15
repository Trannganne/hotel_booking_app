import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_status_chip.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/models_booking/booking_status.dart';

class BookingCardWidget extends StatelessWidget {
  final BookingModel booking;
  final RoomTypeModel? roomType;
  final String orderCode;
  final VoidCallback onDetailTap;
  final VoidCallback? onReviewTap;

  const BookingCardWidget({
    super.key,
    required this.booking,
    this.roomType,
    required this.orderCode,
    required this.onDetailTap,
    this.onReviewTap,
  });

  // ===== Helpers =====

  String get bookingCode =>
      orderCode.isNotEmpty ? orderCode : booking.id ?? "N/A";

  String get stayDateText =>
      "${_formatDate(booking.checkIn)} - ${_formatDate(booking.checkout)}";

  String get totalPriceText => booking.totalPrice != null
      ? "${_formatMoney(booking.totalPrice!)} đ"
      : "Chưa tính";

  String get roomTypeName => roomType?.roomTypeName ?? "Không tìm thấy phòng";

  // ===== UI =====

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
                  child: roomType != null && roomType!.imagesList.isNotEmpty
                      ? Image.network(
                          roomType!.imagesList.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.hotel,
                                size: 64,
                                color: Colors.grey,
                              ),
                        )
                      : const Icon(Icons.hotel, size: 64, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      roomTypeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      'MÃ BOOKING: $bookingCode',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: BookingColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      stayDateText,
                      style: const TextStyle(
                        color: BookingColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: BookingStatusChip(
                        status: _mapStatus(booking.bookingStatus),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      totalPriceText,
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
                    foregroundColor: const Color(0xFF0077FF),
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

              if (booking.bookingStatus == "completed") ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReviewTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077FF),
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

  // ===== Utils =====

  BookingStatus _mapStatus(String status) {
    switch (status) {
      case "pending":
        return BookingStatus.pending;
      case "confirmed":
        return BookingStatus.confirmed;
      case "completed":
        return BookingStatus.completed;
      case "cancelled":
        return BookingStatus.cancelled;
      case "checkin":
        return BookingStatus.checkedIn;
      default:
        return BookingStatus.pending;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatMoney(num value) {
    final text = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}
