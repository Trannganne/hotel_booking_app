import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';

class BookingDetailRealtimeScreen extends StatefulWidget {
  final BookingModel booking;
  final RoomTypeModel? roomType;
  final PaymentModel? payment;

  const BookingDetailRealtimeScreen({
    super.key,
    required this.booking,
    this.roomType,
    this.payment,
  });

  @override
  State<BookingDetailRealtimeScreen> createState() =>
      _BookingDetailRealtimeScreenState();
}

class _BookingDetailRealtimeScreenState
    extends State<BookingDetailRealtimeScreen> {
  final BookingController _bookingController = BookingController();
  late String _status;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _status = widget.booking.bookingStatus;
  }

  String get _bookingCode {
    final code = widget.payment?.orderCode.trim();
    if (code != null && code.isNotEmpty) return code;
    return widget.booking.id ?? 'N/A';
  }

  double get _totalPrice {
    return widget.payment?.totalPrice ?? widget.booking.totalPrice ?? 0;
  }

  int get _nights {
    final days = widget.booking.checkout
        .difference(widget.booking.checkIn)
        .inDays;
    return days <= 0 ? 1 : days;
  }

  bool get _canCancel {
    return _status == 'pending' || _status == 'confirmed';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldShell(
      title: 'LỊCH ĐẶT PHÒNG',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHero(),
                  const SizedBox(height: 12),
                  _buildDateCard(),
                  const SizedBox(height: 12),
                  _buildRoomCard(),
                  const SizedBox(height: 12),
                  _buildAmenityCard(),
                  const SizedBox(height: 12),
                  _buildPolicyCard(),
                  const SizedBox(height: 12),
                  _buildPaymentCard(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    final imageUrl = widget.roomType?.imagesList.isNotEmpty == true
        ? widget.roomType!.imagesList.first
        : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 210,
            child: imageUrl.isEmpty
                ? Container(
                    color: const Color(0xFFD1D5DB),
                    child: const Icon(
                      Icons.hotel,
                      size: 80,
                      color: BookingColors.textSecondary,
                    ),
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFD1D5DB),
                      child: const Icon(
                        Icons.hotel,
                        size: 80,
                        color: BookingColors.textSecondary,
                      ),
                    ),
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _badge(
                  widget.roomType?.roomTypeName ?? 'ROOM',
                  const Color(0xFFE2AA32),
                ),
                _badge('MÃ BOOKING: $_bookingCode', Colors.black),
              ],
            ),
          ),
          const Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Text(
              'Khách sạn Sunrise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    return SectionCard(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: _dateColumn(
              title: 'CHECK-IN',
              weekday: _weekday(widget.booking.checkIn),
              date: _formatDate(widget.booking.checkIn),
              subText: '14:00',
            ),
          ),
          Container(width: 1, height: 90, color: const Color(0xFFD1D5DB)),
          Expanded(
            child: _dateColumn(
              title: 'CHECK-OUT',
              weekday: _weekday(widget.booking.checkout),
              date: _formatDate(widget.booking.checkout),
              subText: '$_nights đêm',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard() {
    final roomCode = widget.booking.roomIds?.isNotEmpty == true
        ? widget.booking.roomIds!.first
        : widget.roomType?.id ?? widget.booking.roomTypeId;

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PHÒNG: $roomCode',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.booking.quantity}x ${widget.roomType?.roomTypeName ?? 'Loại phòng'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Text(
            '${widget.booking.guests} người lớn',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCard() {
    final room = widget.roomType;
    final amenities = <_AmenityItem>[
      const _AmenityItem(Icons.wifi, 'Free Wi-Fi'),
      _AmenityItem(Icons.terrain_outlined, room?.view ?? 'View'),
      const _AmenityItem(Icons.restaurant_outlined, 'Breakfast not included'),
      const _AmenityItem(Icons.smoke_free_outlined, 'Non Smoking'),
      const _AmenityItem(Icons.fitness_center, 'Fitness Center'),
      _AmenityItem(Icons.bed_outlined, _bedText),
      _AmenityItem(
        Icons.people_alt_outlined,
        '${room?.maxOccupancy ?? 1} adults',
      ),
      const _AmenityItem(Icons.balcony_outlined, 'Balcony'),
    ];

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TIỆN ÍCH',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            itemCount: amenities.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final item = amenities[index];
              return Row(
                children: [
                  Icon(item.icon, size: 20, color: const Color(0xFFB8B8B8)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: BookingColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard() {
    return SectionCard(
      margin: EdgeInsets.zero,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHÍNH SÁCH',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 12),
          _BulletText('Không hoàn tiền'),
          SizedBox(height: 8),
          _BulletText('Không đổi lịch'),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    final pricePerNight = widget.roomType?.pricePerNight ?? 0;
    final extraFee = 0;
    final paymentStatus = widget.payment?.status ?? _status;

    return SectionCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THANH TOÁN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          _priceRow('GIÁ MỖI ĐÊM:', '${_formatMoney(pricePerNight)} VND'),
          _priceRow('DỊCH VỤ PHÁT SINH', '${_formatMoney(extraFee)} VND'),
          if (widget.payment != null)
            _priceRow(
              'PHƯƠNG THỨC:',
              _paymentMethodLabel(widget.payment!.paymentMethod),
            ),
          _priceRow(
            'TỔNG TIỀN',
            '${_formatMoney(_totalPrice)} VND (Bao gồm thuế)',
          ),
          const Divider(height: 26),
          _priceRow(
            'TỔNG THU THỰC TẾ:',
            '${_formatMoney(_totalPrice)} VND',
            emphasis: true,
          ),
          _priceRow(
            'TRẠNG THÁI:',
            _paymentStatusLabel(paymentStatus),
            valueColor: _paymentStatusColor(paymentStatus),
          ),
          if (widget.payment == null) ...[
            const SizedBox(height: 8),
            const Text(
              'Chưa có giao dịch thanh toán cho booking này.',
              style: TextStyle(color: BookingColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _canCancel && !_isUpdating ? _cancelBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  disabledBackgroundColor: const Color(0xFFE8E8E8),
                  foregroundColor: BookingColors.danger,
                  minimumSize: const Size.fromHeight(52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Hủy',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chức năng đổi phòng sẽ được xử lý sau.'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BookingColors.primaryLight,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Đổi phòng',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelBooking() async {
    final bookingId = widget.booking.id;
    if (bookingId == null || bookingId.isEmpty) return;

    setState(() => _isUpdating = true);
    await _bookingController.updateBookingStatus(bookingId, 'cancelled');
    if (!mounted) return;

    setState(() {
      _status = 'cancelled';
      _isUpdating = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã hủy đơn đặt phòng.')));
  }

  Widget _dateColumn({
    required String title,
    required String weekday,
    required String date,
    required String subText,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          weekday,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 4),
        Text(subText, style: const TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: color == Colors.black ? 0.86 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool emphasis = false,
    Color? valueColor,
  }) {
    final style = TextStyle(
      fontSize: emphasis ? 16 : 14,
      fontWeight: emphasis ? FontWeight.w900 : FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: style.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  String get _bedText {
    final room = widget.roomType;
    if (room == null) return 'Queen Size Bed';
    final countText = room.bedCount <= 0 ? '' : '${room.bedCount} ';
    return '$countText${room.bedType}'.trim();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _weekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.saturday:
        return 'Thứ Bảy';
      default:
        return 'Chủ Nhật';
    }
  }

  String _formatMoney(num value) {
    final text = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'ĐÃ XÁC NHẬN';
      case 'completed':
        return 'ĐÃ THANH TOÁN';
      case 'cancelled':
        return 'ĐÃ HỦY';
      case 'checkin':
        return 'ĐÃ NHẬN PHÒNG';
      case 'no_show':
        return 'KHÔNG NHẬN PHÒNG';
      default:
        return 'CHỜ XÁC NHẬN';
    }
  }

  String _paymentMethodLabel(String method) {
    switch (method.toUpperCase()) {
      case 'TRANSFER':
        return 'Chuyển khoản';
      case 'CASH':
        return 'Trả tại quầy';
      default:
        return method;
    }
  }

  String _paymentStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return 'ĐÃ THANH TOÁN';
      case 'FAILED':
        return 'THANH TOÁN LỖI';
      case 'CANCELLED':
        return 'ĐÃ HỦY';
      case 'PENDING':
        return 'CHỜ THANH TOÁN';
      default:
        return _statusLabel(status);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
      case 'completed':
      case 'checkin':
        return BookingColors.success;
      case 'cancelled':
      case 'no_show':
        return BookingColors.danger;
      default:
        return BookingColors.primary;
    }
  }

  Color _paymentStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return BookingColors.success;
      case 'FAILED':
      case 'CANCELLED':
        return BookingColors.danger;
      case 'PENDING':
        return BookingColors.primary;
      default:
        return _statusColor(status);
    }
  }
}

class _AmenityItem {
  final IconData icon;
  final String label;

  const _AmenityItem(this.icon, this.label);
}

class _BulletText extends StatelessWidget {
  final String text;

  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 8, color: Color(0xFFE3DCDC)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: BookingColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
