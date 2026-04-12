import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_status.dart';
import 'booking_constants.dart';

/// Badge trạng thái booking.
class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Map trạng thái sang màu badge.
  Color _resolveColor(BookingStatus value) {
    switch (value) {
      case BookingStatus.pending:
        return BookingColors.warning;
      case BookingStatus.confirmed:
        return BookingColors.primary;
      case BookingStatus.checkedIn:
        return BookingColors.success;
      case BookingStatus.completed:
        return BookingColors.success;
      case BookingStatus.cancelled:
        return BookingColors.danger;
    }
  }
}
