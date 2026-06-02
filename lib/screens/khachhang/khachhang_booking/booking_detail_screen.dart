import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/admin/policy/policyController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/controllers/khachhang/notification/notificationController.dart';
import 'package:hotel_booking_app/controllers/khachhang/payment/paymentController.dart';
import 'package:hotel_booking_app/core/Utils/format.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_status_chip.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/OtherModel/booking_view/BookingViewModel.dart';
import 'package:hotel_booking_app/models/models_booking_ui/booking_action_state.dart';
import 'package:hotel_booking_app/models/models_booking_ui/booking_status.dart';
import 'package:hotel_booking_app/screens/khachhang/review/reviewScreen.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:provider/provider.dart';

/// Màn chi tiết của một đơn đặt phòng.
class BookingDetailScreen extends StatefulWidget {
  final BookingModel booking;
  final String orderCode;

  const BookingDetailScreen({
    super.key,
    required this.booking,
    required this.orderCode,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = true;
  String? errorMessage;
  String? cancelReasonText;
  RoomTypeModel? _roomType;
  List<Amenitymodel>? _amenities;
  PolicyModel? _policy;
  PaymentModel? _payment;

  BookingViewModel? _bookingViewModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      final roomTypeController = context.read<RoomTypeController>();
      final amenityController = context.read<AmenityController>();
      final policyController = context.read<Policycontroller>();
      final paymentController = context.read<Paymentcontroller>();

      final rType = await roomTypeController.getRoomTypeById(
        widget.booking.roomTypeId,
      );

      if (rType != null) {
        final amenities = await amenityController.getAmenitiesByIds(
          rType.amensIds,
        );

        final policy = await policyController.getPolicyById(rType.policyId);

        final payment = await paymentController.getPaymentByBookingId(
          widget.booking.id!,
        );

        setState(() {
          _roomType = rType;
          _amenities = amenities;
          _policy = policy;
          _payment = payment;

          _bookingViewModel = BookingViewModel(
            booking: widget.booking,
            roomType: _roomType!,
            amenities: _amenities!,
            nights: widget.booking.checkout
                .difference(widget.booking.checkIn)
                .inDays,
            roomFee: _roomType!.pricePerNight,
            serviceFee: 0.0,
            totalPrice: widget.booking.totalPrice as double,
            payment: _payment,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelBooking() async {
    final now = DateTime.now();

    final canCancel = widget.booking.checkIn.difference(now).inHours >= 24;

    if (!canCancel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không thể hủy phòng trước giờ nhận phòng dưới 24 giờ"),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận hủy phòng"),
        content: const Text(
          "Bạn có chắc chắn muốn hủy đơn đặt phòng này không?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hủy phòng"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final bookingController = context.read<BookingController>();
      final notificationController = context.read<NotificationController>();

      await bookingController.updateBookingStatus(
        widget.booking.id!,
        "cancelled",
      );
      await notificationController.sendCancelNotification(widget.booking.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Hủy phòng thành công")));

      // Tải lại dữ liệu từ Firestore
      await _loadData();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    if (_roomType == null || _amenities == null || _bookingViewModel == null) {
      return const Scaffold(
        body: Center(child: Text('Không tải được dữ liệu')),
      );
    }
    return AppScaffoldShell(
      title: 'CHI TIẾT ĐẶT PHÒNG',
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeaderImage(_roomType!),
                  const SizedBox(height: 16),
                  _buildCheckInCard(widget.booking),
                  const SizedBox(height: 14),
                  _buildRoomInfoCard(widget.booking, _roomType!),
                  const SizedBox(height: 14),
                  _buildAmenityCard(_roomType!, _amenities!),
                  const SizedBox(height: 14),
                  _buildPolicyCard(_policy, widget.booking),
                  const SizedBox(height: 14),
                  _buildPaymentCard(_bookingViewModel!, _roomType!),

                  // Thêm logic Hủy phòng ở đây
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SafeArea(
              top: false,
              child: _buildBottomActionBar(
                BookingActionState(
                  canCancel: true,
                  canChangeRoom: false,
                  canReview: widget.booking.bookingStatus == "completed",
                ),
                _bookingViewModel!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(RoomTypeModel roomType) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Image.network(roomType.imagesList.first, fit: BoxFit.cover),
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
                  text: roomType.roomTypeName,
                  backgroundColor: const Color(0xFFDBB24A),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _TopBadge(
                    text: 'MÃ BOOKING: ${widget.orderCode}',
                    backgroundColor: Colors.black.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              roomType.roomTypeName,
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

  Widget _buildCheckInCard(BookingModel booking) {
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
                  AppFormatter.formatDate(booking.checkIn),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppFormatter.formatDate(booking.checkIn),
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
                  AppFormatter.formatDate(booking.checkout),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${AppFormatter.countNights(booking.checkIn, booking.checkout)} đêm",
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

  Widget _buildRoomInfoCard(BookingModel booking, RoomTypeModel roomType) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  roomType.roomTypeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "${booking.guests} khách",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCard(
    RoomTypeModel roomType,
    List<Amenitymodel> amenities,
  ) {
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
            children: amenities
                .map(
                  (Amenitymodel item) => SizedBox(
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
                            item.amenityName,
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

  Widget _buildPolicyCard(PolicyModel? policy, BookingModel booking) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'CHÍNH SÁCH',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),

          // 1. Dòng bữa sáng
          _buildPolicyRow(
            isValid: policy!.breakfastIncluded,
            trueText: "Có bao gồm bữa ăn sáng",
            falseText: "Không bao gồm bữa ăn sáng",
          ),
          const SizedBox(height: 10),

          // 2. Dòng hoàn tiền
          _buildPolicyRow(
            isValid: policy.isRefundable,
            trueText: "Hoàn tiền khi hủy phòng",
            falseText: "Không hoàn tiền khi hủy phòng",
          ),
          const SizedBox(height: 10),

          // 3. Dòng đổi lịch
          _buildPolicyRow(
            isValid: policy.canReschedule,
            trueText: "Được phép đổi lịch",
            falseText: "Không được phép đổi lịch",
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Color(0xFFEFEFEF)),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              const Text(
                'TRẠNG THÁI ĐƠN:',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const SizedBox(width: 8),
              BookingStatusChip(
                status: BookingStatus.values.firstWhere(
                  (e) => e.name == booking.bookingStatus,
                  orElse: () => BookingStatus.pending,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyRow({
    required bool isValid,
    required String trueText,
    required String falseText,
  }) {
    return Row(
      children: <Widget>[
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 20,
          color: isValid ? const Color(0xFF2D9440) : const Color(0xFFD61F3A),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            isValid ? trueText : falseText,
            style: TextStyle(
              color: isValid ? Colors.black87 : BookingColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(
    BookingViewModel bookingView,
    RoomTypeModel roomType,
  ) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'THANH TOÁN',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          _PriceRow(
            label: 'GIÁ MỖI ĐÊM:',
            value: roomType.pricePerNight.toString(),
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'DỊCH VỤ PHÁT SINH',
            value: bookingView.totalExtraServicesPrice.toString(),
          ),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'TỔNG TIỀN',
            value: '${bookingView.finalInvoiceTotal} (Bao gồm thuế)',
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'TRẠNG THÁI:',
            value: bookingView.payment!.status,
            valueColor: bookingView.payment!.status == "PAID"
                ? BookingColors.success
                : bookingView.booking.bookingStatus == "PENDING"
                ? BookingColors.danger
                : BookingColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BookingActionState
    actionState, // Bạn có thể giữ hoặc xóa tham số này nếu không dùng nữa
    BookingViewModel bookingView,
  ) {
    final status = bookingView.booking.bookingStatus;

    // 1. Trường hợp trạng thái là COMPLETED: Hiện cả Đánh giá & Xem chi tiết
    if (status == "completed") {
      return Row(
        children: <Widget>[
          // NÚT ĐÁNH GIÁ (Bên trái)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Điều hướng sang trang Đánh giá (Ví dụ: RatingScreen)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RatingScreen(booking: bookingView.booking),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0077FF),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'ĐÁNH GIÁ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12), // Khoảng cách giữa 2 nút
        ],
      );
    }

    if (status == "pending") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _cancelBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
          ),
          child: const Text(
            "HỦY PHÒNG",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _TopBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const _TopBadge({required this.text, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
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
          child: Text(value, style: valueStyle, textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
