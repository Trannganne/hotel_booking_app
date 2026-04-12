import 'package:flutter/material.dart';

import 'booking_constants.dart';

/// Khung ảnh placeholder trong lúc chưa có dữ liệu thật.
class PlaceholderImageBox extends StatelessWidget {
  final double height;
  final BorderRadius? borderRadius;
  final String label;
  final IconData icon;

  const PlaceholderImageBox({
    super.key,
    required this.height,
    this.borderRadius,
    this.label = 'Ảnh sẽ hiển thị sau khi kết nối dữ liệu',
    this.icon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: BookingColors.lightBlue,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(color: BookingColors.border),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: BookingColors.primary),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: BookingColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
