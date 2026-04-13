import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/hotel_cover_header.dart';
import 'package:hotel_booking_app/core/widgets/booking/room_card_widget.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_hotel_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_room_ui_model.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

import 'room_detail_booking_screen.dart';

/// Màn chi tiết khách sạn, nơi hiển thị thông tin khách sạn và danh sách loại phòng.
class HotelDetailBookingScreen extends StatelessWidget {
  final BookingFlowService service;

  const HotelDetailBookingScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final BookingHotelUiModel hotel = service.getHotel();
    final List<BookingRoomUiModel> rooms = service.getRooms();

    return AppScaffoldShell(
      title: 'CHI TIẾT KHÁCH SẠN',
      automaticallyImplyLeading: false,
      body: SingleChildScrollView(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HotelCoverHeader(hotel: hotel),
            const SizedBox(height: 16),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${hotel.rating}/10',
                              style: const TextStyle(
                                color: BookingColors.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              'Xuất sắc',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: hotel.highlights
                              .map(
                                (String item) => _HighlightChip(text: item),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: hotel.amenities
                        .map(
                          (String item) => _AmenityTile(text: item),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) {
                  final review = hotel.reviews[index];
                  return SizedBox(
                    width: 290,
                    child: SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFFEAEAEA),
                                child: Text(
                                  review.reviewerName.substring(0, 1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: BookingColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      review.reviewerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      review.reviewTimeText,
                                      style: const TextStyle(
                                        color: BookingColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              review.content,
                              style: const TextStyle(
                                color: BookingColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: hotel.reviews.length,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Các Phòng Có Sẵn',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ...rooms.map(
              (BookingRoomUiModel room) => RoomCardWidget(
                room: room,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => RoomDetailBookingScreen(
                        roomId: room.id,
                        service: service,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  final String text;

  const _HighlightChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.place_outlined, size: 18, color: BookingColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AmenityTile extends StatelessWidget {
  final String text;

  const _AmenityTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: BookingColors.lightBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.check_circle_outline, size: 18, color: BookingColors.primary),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
