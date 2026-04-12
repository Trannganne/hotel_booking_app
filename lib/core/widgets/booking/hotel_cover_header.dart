import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_hotel_ui_model.dart';
import 'booking_constants.dart';
import 'placeholder_image_box.dart';
import 'section_card.dart';

/// Header hiển thị thông tin chính của khách sạn.
class HotelCoverHeader extends StatelessWidget {
  final BookingHotelUiModel hotel;

  const HotelCoverHeader({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: hotel.coverImage == null
              ? const PlaceholderImageBox(
                  height: 260,
                  label: 'Ảnh khách sạn sẽ hiển thị sau khi kết nối dữ liệu',
                )
              : Image.network(
                  hotel.coverImage!,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hotel.location,
                style: const TextStyle(
                  color: BookingColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: BookingColors.lightBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${hotel.rating}/10',
                      style: const TextStyle(
                        color: BookingColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${hotel.reviewCount} đánh giá',
                    style: const TextStyle(
                      color: BookingColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: hotel.highlights
                    .map(
                      (item) => _InfoChip(
                        icon: Icons.place_outlined,
                        label: item,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: hotel.amenities
                    .map(
                      (item) => _InfoChip(
                        icon: Icons.check_circle_outline,
                        label: item,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Chip thông tin nhỏ dùng trong header khách sạn.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BookingColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: BookingColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: BookingColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
