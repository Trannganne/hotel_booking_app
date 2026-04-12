import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_room_ui_model.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

/// Màn đổi phòng cho một booking.
class ChangeRoomScreen extends StatefulWidget {
  final String bookingId;
  final BookingFlowService service;

  const ChangeRoomScreen({
    super.key,
    required this.bookingId,
    required this.service,
  });

  @override
  State<ChangeRoomScreen> createState() => _ChangeRoomScreenState();
}

class _ChangeRoomScreenState extends State<ChangeRoomScreen> {
  String? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    final BookingOrderUiModel booking = widget.service.getBookingById(widget.bookingId);
    final List<BookingRoomUiModel> alternativeRooms = widget.service.getAlternativeRooms(widget.bookingId);

    return AppScaffoldShell(
      title: 'ĐỔI PHÒNG',
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'ĐỔI PHÒNG CHO MÃ ${booking.bookingCode}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SectionCard(
                          child: Row(
                            children: <Widget>[
                              const Text(
                                'Phòng hiện tại: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      booking.roomName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: BookingColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      booking.pricePerNightText,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFFF1895F),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'CÁC LỰA CHỌN CÓ SẴN\n(Cùng ngày: ${booking.checkInDateText} - ${booking.checkOutDateText})',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...alternativeRooms.map(
                    (BookingRoomUiModel room) => _AlternativeRoomCard(
                      room: room,
                      isSelected: selectedRoomId == room.id,
                      differenceText: _differenceText(room.id),
                      onSelect: () {
                        setState(() => selectedRoomId = room.id);
                      },
                      onViewDetail: () {
                        _showRoomBottomSheet(room);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chênh lệch giá sẽ được tính thêm hoặc hoàn lại',
                    style: TextStyle(
                      fontSize: 18,
                      color: BookingColors.textSecondary,
                      fontWeight: FontWeight.w600,
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: BookingColors.textPrimary,
                        side: const BorderSide(color: BookingColors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: const Text(
                        'Quay lại',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedRoomId == null
                          ? null
                          : () {
                              widget.service.changeRoom(
                                bookingId: widget.bookingId,
                                newRoomId: selectedRoomId!,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã cập nhật phòng mới cho booking.'),
                                ),
                              );

                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BookingColors.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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

  String _differenceText(String roomId) {
    final int difference = widget.service.calculateRoomDifference(
      bookingId: widget.bookingId,
      candidateRoomId: roomId,
    );

    if (difference == 0) {
      return 'Không chênh lệch';
    }

    if (difference > 0) {
      return '+ ${widget.service.formatCurrency(difference).replaceFirst('VND ', '')}/ đêm';
    }

    return '- ${widget.service.formatCurrency(difference.abs()).replaceFirst('VND ', '')}/ đêm';
  }

  void _showRoomBottomSheet(BookingRoomUiModel room) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: room.imagePath == null || room.imagePath!.isEmpty
                        ? const PlaceholderImageBox(
                            height: 180,
                            label: 'TODO: Thêm ảnh phòng thay thế vào imagePath trong service',
                          )
                        : Image.asset(
                            room.imagePath!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  room.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  room.shortDescription,
                  style: const TextStyle(
                    color: BookingColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  room.finalPriceText,
                  style: const TextStyle(
                    color: BookingColors.danger,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tiện nghi nổi bật',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                ...room.roomAmenities.map(
                  (String item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AlternativeRoomCard extends StatelessWidget {
  final BookingRoomUiModel room;
  final bool isSelected;
  final String differenceText;
  final VoidCallback onSelect;
  final VoidCallback onViewDetail;

  const _AlternativeRoomCard({
    required this.room,
    required this.isSelected,
    required this.differenceText,
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? BookingColors.primary : BookingColors.lightBorder,
            width: isSelected ? 2 : 1,
          ),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: room.imagePath == null || room.imagePath!.isEmpty
                      ? const PlaceholderImageBox(
                          height: 96,
                          label: 'Ảnh',
                        )
                      : Image.asset(
                          room.imagePath!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      room.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      differenceText,
                      style: const TextStyle(
                        color: Color(0xFFF1895F),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
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
                          style: TextStyle(fontWeight: FontWeight.w800),
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
