import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_hotel_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_room_ui_model.dart';
import 'package:hotel_booking_app/services/booking_mock_service.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/hotel_cover_header.dart';
import 'package:hotel_booking_app/core/widgets/booking/room_card_widget.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_title.dart';
import 'room_detail_booking_screen.dart';

/// Màn chi tiết khách sạn và danh sách loại phòng.
class HotelDetailBookingScreen extends StatelessWidget {
  final String hotelId;
  final BookingMockService service;

  const HotelDetailBookingScreen({
    super.key,
    required this.hotelId,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    // Dữ liệu được lấy từ service để screen chỉ tập trung hiển thị UI.
    final BookingHotelUiModel hotel = service.getHotelDetail(hotelId);
    final List<BookingRoomUiModel> rooms = service.getRoomsByHotel(hotelId);

    return AppScaffoldShell(
      title: 'Chi tiết khách sạn',
      bottomNavigationBar: const BookingBottomNav(currentIndex: 0),
      body: SingleChildScrollView(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HotelCoverHeader(hotel: hotel),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Các Phòng Có Sẵn'),
            const SizedBox(height: 16),
            ...rooms.map(
              (room) => RoomCardWidget(
                room: room,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomDetailBookingScreen(
                        hotelId: hotelId,
                        roomId: room.id,
                        service: service,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
