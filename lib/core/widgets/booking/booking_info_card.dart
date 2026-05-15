import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_review_card_shell.dart';
import 'package:hotel_booking_app/models/models_booking/booking_review_data_model.dart';

/// Card hiển thị thông tin phòng đã chọn.
class BookingInfoCard extends StatelessWidget {
  final BookingReviewDataModel data;

  const BookingInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BookingReviewCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.roomImagePath != null && data.roomImagePath!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                data.roomImagePath!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              const Icon(Icons.apartment_rounded, color: Color(0xFF4B5563)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.hotelName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _infoRow('Nhận phòng', data.checkInText),
          const SizedBox(height: 10),
          _infoRow('Trả phòng', data.checkOutText),
          const Divider(height: 28),
          Text(
            data.roomName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          _featureRow(Icons.straighten_rounded, data.areaText),
          const SizedBox(height: 10),
          _featureRow(Icons.bed_outlined, data.bedText),
          const SizedBox(height: 10),
          _featureRow(Icons.restaurant_outlined, data.breakfastText),
          const SizedBox(height: 10),
          _featureRow(Icons.group_outlined, data.guestText),
          const Divider(height: 28),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Giá phòng',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                data.roomPriceText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE63E57),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String left, String right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(fontSize: 16, color: Color(0xFF111827)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            right,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
