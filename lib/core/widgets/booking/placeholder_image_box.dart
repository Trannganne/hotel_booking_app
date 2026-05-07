import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';

/// Widget ảnh tạm cho các vị trí chưa gắn ảnh thật.
class PlaceholderImageBox extends StatelessWidget {
  final double height;
  final String label;
  final double? width;
  final BorderRadius? borderRadius;
  final IconData icon;

  const PlaceholderImageBox({
    super.key,
    required this.height,
    required this.label,
    this.width,
    this.borderRadius,
    this.icon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: Container(
        width: width ?? double.infinity,
        height: height,
        color: const Color(0xFFF1F5F9),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallBox =
                constraints.maxHeight <= 100 || constraints.maxWidth <= 100;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: isSmallBox ? 24 : 34,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(height: isSmallBox ? 4 : 8),

                    /// Ô nhỏ thì text phải ngắn và giới hạn số dòng.
                    Text(
                      isSmallBox ? 'Ảnh' : label,
                      textAlign: TextAlign.center,
                      maxLines: isSmallBox ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallBox ? 11 : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}