import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_room_ui_model.dart';
import 'package:hotel_booking_app/services/booking_mock_service.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'booking_handoff_placeholder_screen.dart';

/// Màn chi tiết loại phòng.
///
/// Khi bấm nút CHỌN, màn hình sẽ điều hướng sang placeholder/handoff
/// để sau này ghép với phần điền thông tin và thanh toán của thành viên khác.
class RoomDetailBookingScreen extends StatelessWidget {
  final String hotelId;
  final String roomId;
  final BookingMockService service;

  const RoomDetailBookingScreen({
    super.key,
    required this.hotelId,
    required this.roomId,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final BookingRoomUiModel room = service.getRoomDetail(hotelId, roomId);

    return AppScaffoldShell(
      title: 'Chi tiết phòng',
      bottomNavigationBar: const BookingBottomNav(currentIndex: 1),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: room.image == null
                        ? const PlaceholderImageBox(
                            height: 240,
                            label: 'Ảnh chi tiết phòng sẽ hiển thị sau khi kết nối dữ liệu',
                          )
                        : Image.network(
                            room.image!,
                            height: 240,
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
                          room.name,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                room.areaText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                room.bedText,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          room.breakfastText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: BookingColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '2 khách/phòng',
                          style: TextStyle(
                            fontSize: 16,
                            color: BookingColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              room.priceText,
                              style: const TextStyle(
                                color: BookingColors.danger,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '/phòng/đêm',
                              style: TextStyle(
                                color: BookingColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Chưa bao gồm thuế và phí',
                          style: TextStyle(color: BookingColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _TitleDivider(title: 'Chính sách hủy phòng'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: room.policies
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: BookingColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Đặt phòng này có thể hoàn tiền và không thể đổi lịch.',
                    style: TextStyle(
                      fontSize: 15,
                      color: BookingColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _TitleDivider(title: 'Phòng tiện nghi'),
                  const SizedBox(height: 12),
                  ...room.roomAmenities.map(_bulletText),
                  const SizedBox(height: 20),
                  const _TitleDivider(title: 'Trang bị phòng tắm'),
                  const SizedBox(height: 12),
                  ...room.bathroomAmenities.map(_bulletText),
                  const SizedBox(height: 20),
                  Text(
                    room.finalPriceText,
                    style: const TextStyle(
                      color: BookingColors.danger,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Giá cuối cùng',
                    style: TextStyle(color: BookingColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  const _TitleDivider(title: 'Quản lý trạng thái phòng'),
                  const SizedBox(height: 10),
                  const Text(
                    'Sau này có thể bổ sung trạng thái còn phòng / hết phòng từ API hoặc cơ sở dữ liệu.',
                    style: TextStyle(
                      color: BookingColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingHandoffPlaceholderScreen(
                          title: 'Handoff đặt phòng',
                          message:
                              'Điểm handoff hiện tại: ${room.name}. Sau này nối với màn nhập thông tin và thanh toán của thành viên khác.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BookingColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'CHỌN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tạo dòng bullet đơn giản cho danh sách tiện nghi.
  Widget _bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '- $text',
        style: const TextStyle(
          fontSize: 16,
          color: BookingColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Widget tiêu đề + divider dùng nội bộ cho screen chi tiết phòng.
class _TitleDivider extends StatelessWidget {
  final String title;

  const _TitleDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: BookingColors.border),
      ],
    );
  }
}
