import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_room_ui_model.dart';
import 'booking_constants.dart';
import 'placeholder_image_box.dart';
import 'section_card.dart';

/// Card hiển thị một loại phòng trong danh sách phòng của khách sạn.
class RoomCardWidget extends StatelessWidget {
  final BookingRoomUiModel room;
  final VoidCallback onTap;

  const RoomCardWidget({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: room.image == null
                ? const PlaceholderImageBox(
                    height: 170,
                    label: 'Ảnh phòng sẽ hiển thị sau khi kết nối dữ liệu',
                  )
                : Image.network(
                    room.image!,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 14),
          Text(
            room.name,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
              _AmenityMini(icon: Icons.wifi, text: 'Free Wi-Fi'),
              _AmenityMini(icon: Icons.landscape_outlined, text: room.viewText),
              _AmenityMini(
                icon: Icons.free_breakfast_outlined,
                text: room.breakfastText,
              ),
              _AmenityMini(
                icon: Icons.smoke_free_outlined,
                text: room.smokingText,
              ),
              const _AmenityMini(
                icon: Icons.fitness_center,
                text: 'Fitness Center',
              ),
              _AmenityMini(icon: Icons.bed_outlined, text: room.bedText),
              const _AmenityMini(icon: Icons.person_outline, text: '2 adults'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.priceText,
                      style: const TextStyle(
                        color: BookingColors.danger,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Giá hiện tại là mock / placeholder. Có thể thay bằng dữ liệu thật sau.',
                      style: TextStyle(
                        fontSize: 12,
                        color: BookingColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 150,
                height: 48,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BookingColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Book Room',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Item tiện ích nhỏ dùng trong card loại phòng.
class _AmenityMini extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AmenityMini({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: Row(
        children: [
          Icon(icon, size: 17, color: BookingColors.textSecondary),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: BookingColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
