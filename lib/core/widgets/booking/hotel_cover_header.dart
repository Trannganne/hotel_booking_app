import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/models/models_booking/booking_hotel_ui_model.dart';

/// Header ảnh lớn của khách sạn ở màn chi tiết khách sạn.
class HotelCoverHeader extends StatelessWidget {
  final BookingHotelUiModel hotel;

  const HotelCoverHeader({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 235,
            width: double.infinity,
            child: hotel.coverImagePath == null || hotel.coverImagePath!.isEmpty
                ? const PlaceholderImageBox(
                    height: 235,
                    label: 'TODO: Thêm ảnh khách sạn vào coverImagePath trong service',
                  )
                : Image.asset(
                    hotel.coverImagePath!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withOpacity(0.08),
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                hotel.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hotel.location,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${hotel.rating}/10',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: BookingColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${hotel.reviewCount} đánh giá',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
