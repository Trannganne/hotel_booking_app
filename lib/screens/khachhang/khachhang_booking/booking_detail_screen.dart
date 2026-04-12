import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_status_chip.dart';
import 'package:hotel_booking_app/core/widgets/booking/cancel_booking_dialog.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_action_state.dart';
import 'package:hotel_booking_app/models/models_booking/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_room_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_status.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

import 'booking_handoff_placeholder_screen.dart';
import 'change_room_screen.dart';

/// Màn chi tiết của một đơn đặt phòng.
class BookingDetailScreen extends StatefulWidget {
  final String bookingId;
  final BookingFlowService service;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    required this.service,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  String? cancelReasonText;

  @override
  Widget build(BuildContext context) {
    final BookingOrderUiModel booking = widget.service.getBookingById(widget.bookingId);
    final BookingRoomUiModel room = widget.service.getRoomById(booking.roomId);
    final BookingActionState actionState = widget.service.getActionState(widget.bookingId);

    return AppScaffoldShell(
      title: 'LỊCH ĐẶT PHÒNG',
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeaderImage(booking),
                  const SizedBox(height: 16),
                  _buildCheckInCard(booking),
                  const SizedBox(height: 14),
                  _buildRoomInfoCard(booking),
                  const SizedBox(height: 14),
                  _buildAmenityCard(room),
                  const SizedBox(height: 14),
                  _buildPolicyCard(room, booking),
                  const SizedBox(height: 14),
                  _buildPaymentCard(booking),
                  if (cancelReasonText != null || booking.cancelReason != null) ...<Widget>[
                    const SizedBox(height: 14),
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Lý do hủy',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cancelReasonText ?? booking.cancelReason ?? '',
                            style: const TextStyle(
                              color: BookingColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SafeArea(
              top: false,
              child: _buildBottomActionBar(actionState, booking),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BookingOrderUiModel booking) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 220,
            width: double.infinity,
            child: booking.hotelImagePath == null || booking.hotelImagePath!.isEmpty
                ? const PlaceholderImageBox(
                    height: 220,
                    label: 'TODO: Thêm ảnh khách sạn cho booking trong service',
                  )
                : Image.asset(
                    booking.hotelImagePath!,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
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
            top: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _TopBadge(
                  text: booking.roomTypeBadge,
                  backgroundColor: const Color(0xFFDBB24A),
                ),
                _TopBadge(
                  text: 'MÃ BOOKING: ${booking.bookingCode}',
                  backgroundColor: Colors.black.withOpacity(0.72),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              booking.hotelName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(BookingOrderUiModel booking) {
    return SectionCard(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                const Text(
                  'CHECK-IN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  booking.checkInDateText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  booking.checkInTimeText,
                  style: const TextStyle(
                    fontSize: 17,
                    color: BookingColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 90, color: BookingColors.lightBorder),
          Expanded(
            child: Column(
              children: <Widget>[
                const Text(
                  'CHECK-OUT',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  booking.checkOutDateText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  booking.totalNightsText,
                  style: const TextStyle(
                    fontSize: 17,
                    color: BookingColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfoCard(BookingOrderUiModel booking) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'PHÒNG: ${booking.roomCode}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  booking.roomName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            booking.guestText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCard(BookingRoomUiModel room) {
    final List<String> amenityLines = <String>[
      'Free Wi-Fi',
      room.viewText,
      room.breakfastText,
      room.smokingText,
      'Fitness Center',
      room.bedText,
      room.capacityText,
      'Balcony',
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'TIỆN ÍCH',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: amenityLines
                .map(
                  (String item) => SizedBox(
                    width: 150,
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: BookingColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: BookingColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard(BookingRoomUiModel room, BookingOrderUiModel booking) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'CHÍNH SÁCH',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...room.policies.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Color(0xFFD6CFD1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(
                      color: BookingColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const Text(
                'TRẠNG THÁI:',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              BookingStatusChip(status: booking.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BookingOrderUiModel booking) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'THANH TOÁN',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          _PriceRow(label: 'GIÁ MỖI ĐÊM:', value: booking.pricePerNightText),
          const SizedBox(height: 8),
          _PriceRow(label: 'DỊCH VỤ PHÁT SINH', value: booking.extraFeeText),
          const SizedBox(height: 8),
          _PriceRow(label: 'TỔNG TIỀN', value: '${booking.paidTotalText} (Bao gồm thuế)'),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'TỔNG THU THỰC TẾ:',
            value: booking.paidTotalText,
            isEmphasis: true,
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'TRẠNG THÁI:',
            value: booking.status.label,
            valueColor: booking.status == BookingStatus.completed
                ? BookingColors.success
                : booking.status == BookingStatus.cancelled
                    ? BookingColors.danger
                    : BookingColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BookingActionState actionState,
    BookingOrderUiModel booking,
  ) {
    if (actionState.canCancel || actionState.canChangeRoom) {
      return Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed: actionState.canCancel
                  ? () async {
                      final String? reason = await showCancelBookingDialog(context);
                      if (!mounted) return;
                      if (!widget.service.isValidCancelReason(reason)) return;

                      widget.service.cancelBooking(
                        bookingId: booking.id,
                        reason: reason!.trim(),
                      );

                      setState(() {
                        cancelReasonText = reason.trim();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã cập nhật trạng thái đơn sang Đã hủy.'),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8E8E8),
                foregroundColor: BookingColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                minimumSize: const Size.fromHeight(54),
                elevation: 0,
              ),
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton(
              onPressed: actionState.canChangeRoom
                  ? () async {
                      await Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ChangeRoomScreen(
                            bookingId: booking.id,
                            service: widget.service,
                          ),
                        ),
                      );

                      if (mounted) {
                        setState(() {});
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: BookingColors.primaryLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                minimumSize: const Size.fromHeight(54),
              ),
              child: const Text(
                'Đổi phòng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      );
    }

    if (actionState.canReview) {
      return Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const BookingHandoffPlaceholderScreen(
                      titleText: 'ĐÁNH GIÁ KHÁCH SẠN',
                      description: 'Màn này được chừa sẵn để sau này nối với '
                          'phần đánh giá của nhóm.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BookingColors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'ĐÁNH GIÁ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _TopBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const _TopBadge({
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmphasis;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontWeight: isEmphasis ? FontWeight.w900 : FontWeight.w700,
      fontSize: isEmphasis ? 18 : 16,
    );

    final TextStyle valueStyle = TextStyle(
      fontWeight: isEmphasis ? FontWeight.w900 : FontWeight.w700,
      fontSize: isEmphasis ? 18 : 16,
      color: valueColor ?? BookingColors.textPrimary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Text(label, style: labelStyle)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
