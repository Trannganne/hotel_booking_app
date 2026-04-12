import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_room_ui_model.dart';
import 'package:hotel_booking_app/services/booking_mock_service.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'booking_handoff_placeholder_screen.dart';

/// Màn đổi phòng cho một booking đã chọn.
///
/// Screen chỉ quản lý trạng thái chọn item trên UI.
/// Danh sách phòng thay thế và logic xác định phòng được chọn đều do service xử lý.
class ChangeRoomScreen extends StatefulWidget {
  final String bookingId;
  final BookingMockService service;

  const ChangeRoomScreen({
    super.key,
    required this.bookingId,
    required this.service,
  });

  @override
  State<ChangeRoomScreen> createState() => _ChangeRoomScreenState();
}

class _ChangeRoomScreenState extends State<ChangeRoomScreen> {
  /// roomId đang được người dùng chọn để đổi.
  String? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    final BookingOrderUiModel booking =
        widget.service.getBookingDetail(widget.bookingId);

    final List<BookingRoomUiModel> alternatives =
        widget.service.getAlternativeRoomsForBooking(widget.bookingId);

    return AppScaffoldShell(
      title: 'ĐỔI PHÒNG',
      bottomNavigationBar: const BookingBottomNav(currentIndex: 3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'ĐỔI PHÒNG CHO MÃ ${booking.bookingCode}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Phòng hiện tại.
                  SectionCard(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: BookingColors.textPrimary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Phòng hiện tại: ',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                            text: booking.roomInfoText,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const TextSpan(text: '\\n'),
                          const TextSpan(
                            text: '328.xxx',
                            style: TextStyle(
                              color: Color(0xFFFC7E51),
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'CÁC LỰA CHỌN CÓ SẴN',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      '(Cùng ngày: ${_dateRange(booking)})',
                      style: const TextStyle(
                        fontSize: 16,
                        color: BookingColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Danh sách phòng thay thế.
                  ...alternatives.map(
                    (room) => _AlternativeRoomCard(
                      room: room,
                      isSelected: selectedRoomId == room.id,
                      onSelect: () => setState(() => selectedRoomId = room.id),
                      onViewDetail: () => _showAlternativeRoomDetail(room),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Chênh lệch giá sẽ được tính thêm hoặc hoàn lại',
                      style: TextStyle(
                        fontSize: 16,
                        color: BookingColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Thanh action dưới cùng.
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: BookingColors.textPrimary,
                        side: const BorderSide(color: BookingColors.black),
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Quay lại',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedRoomId == null ? null : _onConfirmChangeRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BookingColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Trả về nhãn khoảng ngày ngắn gọn từ service.
  String _dateRange(BookingOrderUiModel booking) {
    return widget.service.buildShortDateRange(booking);
  }

  /// Hiển thị chi tiết nhanh của một phòng thay thế.
  void _showAlternativeRoomDetail(BookingRoomUiModel room) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: BookingColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    room.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const PlaceholderImageBox(
                    height: 180,
                    label: 'Ảnh phòng thay thế sẽ hiển thị sau khi kết nối dữ liệu',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    room.priceText,
                    style: const TextStyle(
                      color: Color(0xFFFC7E51),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Diện tích: ${room.areaText}'),
                  Text('Giường: ${room.bedText}'),
                  Text('View: ${room.viewText}'),
                  Text('Ăn sáng: ${room.breakfastText}'),
                  const SizedBox(height: 14),
                  const Text(
                    'Tiện nghi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ...room.roomAmenities.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('- $item'),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Xử lý xác nhận đổi phòng.
  Future<void> _onConfirmChangeRoom() async {
    final selectedRoom = widget.service.findAlternativeRoomById(
      bookingId: widget.bookingId,
      roomId: selectedRoomId,
    );

    if (selectedRoom == null) {
      return;
    }

    final roomName = widget.service.buildChangeRoomHandoffLabel(selectedRoom);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingHandoffPlaceholderScreen(
          title: 'Handoff thanh toán đổi phòng',
          message:
              'Điểm handoff hiện tại: $roomName. Sau này nối sang phần thanh toán của nhóm.',
        ),
      ),
    );
  }
}

/// Card hiển thị một lựa chọn phòng thay thế.
class _AlternativeRoomCard extends StatelessWidget {
  final BookingRoomUiModel room;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onViewDetail;

  const _AlternativeRoomCard({
    required this.room,
    required this.isSelected,
    required this.onSelect,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? BookingColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: SectionCard(
          margin: EdgeInsets.zero,
          child: Row(
            children: [
              const SizedBox(
                width: 96,
                height: 96,
                child: PlaceholderImageBox(height: 96, label: 'Ảnh'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      room.priceText,
                      style: const TextStyle(
                        color: Color(0xFFFC7E51),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onViewDetail,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: BookingColors.textPrimary,
                          side: const BorderSide(color: BookingColors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'XEM CHI TIẾT',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
