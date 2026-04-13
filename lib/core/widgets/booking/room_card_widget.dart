import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_room_ui_model.dart';

/// Card hiển thị một loại phòng ở màn chi tiết khách sạn.
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
    return GestureDetector(
      onTap: onTap,
      child: SectionCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: room.imagePath == null || room.imagePath!.isEmpty
                    ? const PlaceholderImageBox(
                        height: 170,
                        label: 'TODO: Thêm ảnh loại phòng vào imagePath trong service',
                      )
                    : Image.asset(
                        room.imagePath!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              room.shortDescription,
              style: const TextStyle(
                color: BookingColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: <Widget>[
                _MetaItem(icon: Icons.wifi, text: 'Free Wi-Fi'),
                _MetaItem(icon: Icons.landscape_outlined, text: room.viewText),
                _MetaItem(icon: Icons.restaurant_outlined, text: room.breakfastText),
                _MetaItem(icon: Icons.smoke_free_outlined, text: room.smokingText),
                _MetaItem(icon: Icons.fitness_center_outlined, text: 'Fitness Center'),
                _MetaItem(icon: Icons.bed_outlined, text: room.bedText),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        room.priceText,
                        style: const TextStyle(
                          color: BookingColors.danger,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Giá cuối cùng: ${room.finalPriceText}',
                        style: const TextStyle(
                          color: BookingColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BookingColors.primaryLight,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'XEM CHI TIẾT',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18, color: BookingColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: BookingColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
