import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/models_booking/booking_status.dart';

/// Chip hiển thị trạng thái booking.
class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final _StatusVisual visual = _visualByStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: visual.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: visual.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _StatusVisual _visualByStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return const _StatusVisual(
          background: Color(0xFFFFF1C9),
          foreground: Color(0xFFB27800),
        );
      case BookingStatus.confirmed:
        return const _StatusVisual(
          background: Color(0xFFDDF2E3),
          foreground: Color(0xFF2D9440),
        );
      case BookingStatus.checkedIn:
        return const _StatusVisual(
          background: Color(0xFFDFF0FF),
          foreground: Color(0xFF0077FF),
        );
      case BookingStatus.completed:
        return const _StatusVisual(
          background: Color(0xFFDDF2E3),
          foreground: Color(0xFF2D9440),
        );
      case BookingStatus.cancelled:
        return const _StatusVisual(
          background: Color(0xFFFFE1E5),
          foreground: Color(0xFFD61F3A),
        );
    }
  }
}

class _StatusVisual {
  final Color background;
  final Color foreground;

  const _StatusVisual({
    required this.background,
    required this.foreground,
  });
}
