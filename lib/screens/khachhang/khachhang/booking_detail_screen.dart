import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_action_state.dart';
import 'package:hotel_booking_app/models/models/booking_order_ui_model.dart';
import 'package:hotel_booking_app/services/booking_mock_service.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_status_chip.dart';
import 'package:hotel_booking_app/core/widgets/booking/cancel_booking_dialog.dart';
import 'package:hotel_booking_app/core/widgets/booking/placeholder_image_box.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'booking_handoff_placeholder_screen.dart';
import 'change_room_screen.dart';

/// Màn chi tiết của một đơn đặt phòng.
///
/// Screen này chỉ lo phần hiển thị và điều hướng.
/// Các rule như hủy được không, đổi phòng được không, có được đánh giá không
/// đều do service quyết định.
class BookingDetailScreen extends StatefulWidget {
  final String bookingId;
  final BookingMockService service;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    required this.service,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  /// Lưu lý do hủy gần nhất để tiện debug/mock UI.
  String? cancelReason;

  @override
  Widget build(BuildContext context) {
    final BookingOrderUiModel booking =
        widget.service.getBookingDetail(widget.bookingId);

    // Quyền thao tác được tính trong service, không viết thẳng trong UI.
    final BookingActionState actionState =
        widget.service.getBookingActionState(booking);

    final checkInWeekday = widget.service.getWeekdayLabel(booking.checkInDate);
    final checkOutWeekday = widget.service.getWeekdayLabel(booking.checkOutDate);

    return AppScaffoldShell(
      title: 'LỊCH ĐẶT PHÒNG',
      bottomNavigationBar: const BookingBottomNav(currentIndex: 3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header ảnh booking / khách sạn.
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: const PlaceholderImageBox(
                          height: 220,
                          label:
                              'Ảnh khách sạn / booking sẽ hiển thị sau khi kết nối dữ liệu',
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: _DarkTag(text: booking.roomName.toUpperCase()),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: _DarkTag(text: 'MÃ BOOKING: ${booking.bookingCode}'),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 18,
                        right: 16,
                        child: Text(
                          booking.hotelName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Khối check-in / check-out.
                  SectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'CHECK-IN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                checkInWeekday,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(booking.checkInDate),
                              const SizedBox(height: 6),
                              const Text('14:00'),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 100,
                          color: BookingColors.border,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'CHECK-OUT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                checkOutWeekday,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(booking.checkOutDate),
                              const SizedBox(height: 6),
                              Text(booking.stayText),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Thông tin phòng đã đặt.
                  SectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PHÒNG: ${booking.roomCode}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                booking.roomInfoText,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${booking.adults} người lớn',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tiện ích.
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TIỆN ÍCH',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 16,
                          runSpacing: 14,
                          children: booking.amenities
                              .map((item) => _InfoIconText(text: item))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chính sách.
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CHÍNH SÁCH',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ...booking.policies.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFFE2D8D8),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: BookingColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Khối thanh toán.
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'THANH TOÁN',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 14),
                        _PaymentRow(label: 'GIÁ MỖI ĐÊM:', value: booking.nightlyPriceText),
                        const SizedBox(height: 8),
                        const _PaymentRow(label: 'DỊCH VỤ PHÁT SINH', value: '0 VND'),
                        const SizedBox(height: 8),
                        _PaymentRow(
                          label: 'TỔNG TIỀN',
                          value: '${booking.totalPriceText} (Bao gồm thuế)',
                        ),
                        const Divider(height: 28),
                        _PaymentRow(
                          label: 'TỔNG THU THỰC TẾ:',
                          value: booking.totalActualText,
                          isStrong: true,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'TRẠNG THÁI:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            BookingStatusChip(status: booking.status),
                          ],
                        ),
                        if (cancelReason != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Lý do hủy đã chọn: $cancelReason',
                            style: const TextStyle(
                              color: BookingColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
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
                  if (actionState.canCancel || actionState.canChangeRoom) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: actionState.canCancel ? _onCancelPressed : null,
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: actionState.canChangeRoom
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChangeRoomScreen(
                                      bookingId: booking.id,
                                      service: widget.service,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BookingColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          minimumSize: const Size.fromHeight(54),
                        ),
                        child: const Text(
                          'Đổi phòng',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ] else if (actionState.canReview) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BookingHandoffPlaceholderScreen(
                                title: 'Màn đánh giá',
                                message:
                                    'Đây là điểm handoff tạm cho màn đánh giá. Sau này nối với phần đánh giá thật của nhóm.',
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xử lý luồng hủy booking.
  ///
  /// Screen chỉ mở dialog và hiển thị kết quả.
  /// Việc kiểm tra hợp lệ và tạo message do service đảm nhiệm.
  Future<void> _onCancelPressed() async {
    final booking = widget.service.getBookingDetail(widget.bookingId);
    final reason = await showCancelBookingDialog(context);

    if (!mounted) {
      return;
    }

    final validationMessage = widget.service.validateCancelReason(reason);

    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    final safeReason = reason!.trim();
    final message = widget.service.buildCancelBookingMessage(
      booking: booking,
      reason: safeReason,
    );

    setState(() => cancelReason = safeReason);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Tag tối dùng trên header booking.
class _DarkTag extends StatelessWidget {
  final String text;

  const _DarkTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Item tiện ích nhỏ trong màn chi tiết booking.
class _InfoIconText extends StatelessWidget {
  final String text;

  const _InfoIconText({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 18,
            color: BookingColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: BookingColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dòng hiển thị label - value cho khu vực thanh toán.
class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: isStrong ? 18 : 16,
      fontWeight: isStrong ? FontWeight.w800 : FontWeight.w600,
      color: BookingColors.textPrimary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: textStyle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
