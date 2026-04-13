import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_room_ui_model.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';
import 'package:hotel_booking_app/screens/khachhang/khachhang_booking/booking_review_screen.dart';
import 'package:hotel_booking_app/services/booking_review_service.dart';

/// Màn chi tiết loại phòng.
class RoomDetailBookingScreen extends StatelessWidget {
  final String roomId;
  final String hotelName;
  final BookingFlowService service;
  final BookingReviewService _bookingReviewService =
      const BookingReviewService();

  const RoomDetailBookingScreen({
    super.key,
    required this.roomId,
    required this.hotelName,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final BookingRoomUiModel room = service.getRoomById(roomId);

    return AppScaffoldShell(
      title: 'Chi tiết phòng',
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: room.imagePath == null || room.imagePath!.isEmpty
                        ? const PlaceholderImageBox(
                            height: 250,
                            label:
                                'TODO: Thêm ảnh loại phòng vào imagePath trong service',
                          )
                        : Image.asset(room.imagePath!, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    room.areaText,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    room.bedText,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    room.breakfastText,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: BookingColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    room.capacityText,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: BookingColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  room.priceText,
                                  style: const TextStyle(
                                    color: BookingColors.danger,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Text(
                                  '/phòng/đêm',
                                  style: TextStyle(
                                    color: BookingColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Chính sách hủy phòng',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: room.policies
                              .map(
                                (String item) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDEDED),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: BookingColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Đặt phòng này có thể hoàn tiền và không thể đổi lịch',
                          style: TextStyle(
                            color: BookingColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(title: 'Phòng tiện nghi'),
                        _BulletSection(items: room.roomAmenities),
                        const SizedBox(height: 14),
                        _SectionTitle(title: 'Trang bị phòng tắm'),
                        _BulletSection(items: room.bathroomAmenities),
                        const SizedBox(height: 20),
                        Text(
                          room.finalPriceText,
                          style: const TextStyle(
                            color: BookingColors.danger,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'Giá cuối cùng',
                          style: TextStyle(
                            color: BookingColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Quản lý trạng thái phòng',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Hiện tại nút CHỌN chỉ điều hướng sang màn placeholder để '
                                'sau này nối tiếp với phần nhập thông tin / thanh toán của nhóm.',
                                style: TextStyle(
                                  color: BookingColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final reviewData = _bookingReviewService
                        .buildFromSelectedRoom(
                          hotelName: hotelName,
                          room: room,
                        );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingReviewScreen(
                          data: reviewData,

                          /// TODO:
                          /// Nối màn thanh toán của thành viên khác tại đây.
                          /// Ví dụ:
                          /// nextScreenBuilder: (_) => const ThanhtoanScreen(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BookingColors.primaryLight,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'CHỌN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
    );
  }
}

class _BulletSection extends StatelessWidget {
  final List<String> items;

  const _BulletSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (String item) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
