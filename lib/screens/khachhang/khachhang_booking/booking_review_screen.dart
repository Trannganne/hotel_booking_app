import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:hotel_booking_app/controllers/auth/AuthContronller.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';
import 'package:hotel_booking_app/models/models_booking/booking_review_data_model.dart';
import 'package:hotel_booking_app/screens/khachhang/payment/paymentScreen.dart';

class BookingReviewScreen extends StatefulWidget {
  final BookingReviewDataModel data;
  final RoomTypeModel? roomType;
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final int initialQuantity;
  final int initialGuests;
  final WidgetBuilder? nextScreenBuilder;

  const BookingReviewScreen({
    super.key,
    required this.data,
    this.roomType,
    this.initialCheckIn,
    this.initialCheckOut,
    this.initialQuantity = 1,
    this.initialGuests = 1,
    this.nextScreenBuilder,
  });

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  static const Color _primary = Color(0xFF0077FF);
  static const Color _darkText = Color(0xFF111827);
  static const Color _mutedText = Color(0xFF6B7280);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _specialRequestController;

  late DateTime _checkIn;
  late DateTime _checkOut;
  late int _quantity;
  late int _guests;

  bool _bookingForSelf = true;
  bool _isLoadingProfile = true;
  bool _isSubmitting = false;
  UserModel? _profile;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkIn = widget.initialCheckIn ?? now;
    _checkOut =
        widget.initialCheckOut ?? DateTime(now.year, now.month, now.day + 1);
    _quantity = widget.initialQuantity < 1 ? 1 : widget.initialQuantity;
    _guests = widget.initialGuests < 1 ? 1 : widget.initialGuests;

    _nameController = TextEditingController(text: widget.data.customerName);
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _specialRequestController = TextEditingController(
      text: widget.data.specialRequestText,
    );

    _loadAccountInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountInfo() async {
    final auth = context.read<Authcontronller>();
    UserModel? profile;

    try {
      profile = await auth.getCurrentUserProfile();
    } catch (_) {
      profile = null;
    }

    if (!mounted) return;

    final firebaseUser = auth.currentUser;
    final name = _firstNotEmpty([
      profile?.fullName,
      firebaseUser?.displayName,
      widget.data.customerName,
      'Khách hàng',
    ]);
    final email = _firstNotEmpty([profile?.email, firebaseUser?.email]);
    final phone = _firstNotEmpty([
      profile?.phoneNumber,
      firebaseUser?.phoneNumber,
    ]);

    setState(() {
      _profile = profile;
      _nameController.text = name;
      _emailController.text = email;
      _phoneController.text = phone;
      _isLoadingProfile = false;
    });
  }

  String _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  double get _roomPrice => widget.roomType?.pricePerNight ?? 0;

  double get _totalPrice => _roomPrice * _quantity;

  int get _maxGuests {
    final maxOccupancy = widget.roomType?.maxOccupancy ?? 1;
    final safeMax = maxOccupancy < 1 ? 1 : maxOccupancy;
    return safeMax * _quantity;
  }

  String get _contactSummary {
    final parts = <String>[
      if (_emailController.text.trim().isNotEmpty) _emailController.text.trim(),
      if (_phoneController.text.trim().isNotEmpty) _phoneController.text.trim(),
    ];
    return parts.isEmpty ? 'Chưa có thông tin liên hệ' : parts.join(' · ');
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  String _formatMoney(num value) {
    return '${NumberFormat.decimalPattern('vi_VN').format(value.round())} VND';
  }

  Future<void> _selectCheckInDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn.isBefore(today) ? today : _checkIn,
      firstDate: today,
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
      builder: _datePickerTheme,
    );

    if (picked == null) return;

    setState(() {
      _checkIn = picked;
      if (!_checkOut.isAfter(_checkIn)) {
        _checkOut = _checkIn.add(const Duration(days: 1));
      }
    });
  }

  Future<void> _selectCheckOutDate() async {
    final firstDate = _checkIn.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOut.isBefore(firstDate) ? firstDate : _checkOut,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
      builder: _datePickerTheme,
    );

    if (picked == null) return;

    setState(() {
      _checkOut = picked;
    });
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: _primary,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: _darkText,
        ),
      ),
      child: child ?? const SizedBox(),
    );
  }

  void _changeQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 999);
      if (_guests > _maxGuests) {
        _guests = _maxGuests;
      }
    });
  }

  void _changeGuests(int delta) {
    setState(() {
      _guests = (_guests + delta).clamp(1, _maxGuests);
    });
  }

  void _selectBookingOwner(bool forSelf) {
    setState(() {
      _bookingForSelf = forSelf;
      if (forSelf) {
        _nameController.text = _firstNotEmpty([
          _profile?.fullName,
          context.read<Authcontronller>().currentUser?.displayName,
          'Khách hàng',
        ]);
        _emailController.text = _firstNotEmpty([
          _profile?.email,
          context.read<Authcontronller>().currentUser?.email,
        ]);
        _phoneController.text = _firstNotEmpty([
          _profile?.phoneNumber,
          context.read<Authcontronller>().currentUser?.phoneNumber,
        ]);
      } else {
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
      }
    });
  }

  bool _validateBeforeContinue() {
    if (widget.roomType == null) {
      return widget.nextScreenBuilder != null;
    }

    if (widget.roomType!.id == null || widget.roomType!.id!.trim().isEmpty) {
      _showMessage('Không tìm thấy mã loại phòng.');
      return false;
    }

    if (_checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn)) {
      _showMessage('Ngày trả phòng phải sau ngày nhận phòng.');
      return false;
    }

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_emailController.text.trim().isEmpty &&
        _phoneController.text.trim().isEmpty) {
      _showMessage('Vui lòng nhập email hoặc số điện thoại liên hệ.');
      return false;
    }

    return true;
  }

  Future<void> _handleContinue() async {
    FocusScope.of(context).unfocus();
    if (!_validateBeforeContinue()) return;

    if (widget.roomType == null && widget.nextScreenBuilder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: widget.nextScreenBuilder!),
      );
      return;
    }

    final auth = context.read<Authcontronller>();
    final userId = auth.uid;
    if (userId == null || userId.isEmpty) {
      _showMessage('Bạn cần đăng nhập trước khi đặt phòng.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final request = CreateBookingRequest(
      userId: userId,
      roomTypeId: widget.roomType!.id!,
      checkIn: _checkIn,
      checkOut: _checkOut,
      quantity: _quantity,
      guests: _guests,
      totalPrice: _totalPrice,
      bookingForSelf: _bookingForSelf,
      contactName: _nameController.text.trim(),
      contactEmail: _emailController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      specialRequest: _specialRequestController.text.trim(),
    );

    final bookingController = context.read<BookingController>();
    await bookingController.createBooking(request);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    final booking = bookingController.lastBooking;
    if (booking == null) {
      _showMessage(bookingController.errorMessage ?? 'Không thể tạo booking.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ThanhToanScreen(booking: booking)),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 22),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBookingSummaryCard(),
                    const SizedBox(height: 16),
                    _buildContactSection(),
                    const SizedBox(height: 18),
                    _buildSpecialRequestSection(),
                    const SizedBox(height: 18),
                    _buildPaymentDetailSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: _primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      widget.data.hotelName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Chạm vào ngày bên dưới để thay đổi lịch đặt phòng',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.apartment_rounded, color: _primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.data.hotelName,
                  style: const TextStyle(
                    color: _darkText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _dateRow('Nhận phòng', _checkIn, _selectCheckInDate),
          const SizedBox(height: 12),
          _dateRow('Trả phòng', _checkOut, _selectCheckOutDate),
          const Divider(height: 30),
          Text(
            '(${_quantity}x) ${widget.data.roomName}',
            style: const TextStyle(
              color: _darkText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _featureRow(Icons.people_alt_outlined, '$_guests khách'),
          _featureRow(Icons.bed_outlined, widget.data.bedText),
          _featureRow(Icons.restaurant_outlined, widget.data.breakfastText),
          _featureRow(Icons.straighten_rounded, widget.data.areaText),
          const Divider(height: 30),
          _policyRow(
            'Miễn phí hủy phòng trong 2 giờ sau khi xác nhận đặt phòng',
          ),
          const SizedBox(height: 8),
          _policyRow('Có thể đổi lịch theo chính sách khách sạn'),
        ],
      ),
    );
  }

  Widget _dateRow(String label, DateTime value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              _formatDate(value),
              style: const TextStyle(
                color: _darkText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_month, color: _primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icon, color: _mutedText, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _mutedText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _policyRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, color: Color(0xFF16A34A), size: 26),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF138A42),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _loginInfoRow(),
        const SizedBox(height: 18),
        const Text(
          'Thông tin liên hệ (nhận vé/phiếu thanh toán)',
          style: TextStyle(
            color: _darkText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_bookingForSelf) ...[
                Text(
                  _isLoadingProfile
                      ? 'Đang tải thông tin...'
                      : _nameController.text,
                  style: const TextStyle(
                    color: _darkText,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _contactSummary,
                  style: const TextStyle(
                    color: _darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
              ],
              _radioRow(
                title: 'Tôi đặt cho bản thân',
                selected: _bookingForSelf,
                onTap: () => _selectBookingOwner(true),
              ),
              const SizedBox(height: 12),
              _radioRow(
                title: 'Tôi đặt cho người khác',
                selected: !_bookingForSelf,
                onTap: () => _selectBookingOwner(false),
              ),
              if (!_bookingForSelf) ...[
                const SizedBox(height: 18),
                _input(
                  controller: _nameController,
                  label: 'Họ tên người nhận phòng',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ tên.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _input(
                  controller: _emailController,
                  label: 'Email liên hệ',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _input(
                  controller: _phoneController,
                  label: 'Số điện thoại liên hệ',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginInfoRow() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: _primary,
          ),
          child: const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 34,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLoadingProfile
                    ? 'Đang tải tài khoản'
                    : 'Đăng nhập bằng ${_nameController.text}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _darkText,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.data.loginMethodText,
                style: const TextStyle(color: _mutedText, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _radioRow({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? _primary : _mutedText,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _darkText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (selected)
            const Icon(Icons.check, color: Color(0xFF16A34A), size: 30),
        ],
      ),
    );
  }

  Widget _buildSpecialRequestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yêu cầu đặc biệt',
          style: TextStyle(
            color: _darkText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        _card(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: TextField(
            controller: _specialRequestController,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Thêm yêu cầu đặc biệt',
              suffixIcon: Icon(Icons.add_circle, color: _primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chi tiết phí thanh toán',
          style: TextStyle(
            color: _darkText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        _card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  children: [
                    _priceLine('Giá phòng đã chọn', _formatMoney(_roomPrice)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Số phòng muốn đặt',
                            style: TextStyle(
                              color: _darkText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _counterButton(Icons.remove, () => _changeQuantity(-1)),
                        _counterValue(_quantity),
                        _counterButton(Icons.add, () => _changeQuantity(1)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Số khách (tối đa $_maxGuests)',
                            style: const TextStyle(
                              color: _darkText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _counterButton(Icons.remove, () => _changeGuests(-1)),
                        _counterValue(_guests),
                        _counterButton(Icons.add, () => _changeGuests(1)),
                      ],
                    ),
                    const Divider(height: 30),
                    _priceLine(
                      'Tổng giá tiền',
                      _formatMoney(_totalPrice),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7FD),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Text(
                  'Tổng tiền = số phòng ($_quantity) x giá phòng đã chọn',
                  style: const TextStyle(
                    color: Color(0xFF1685C7),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceLine(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: _darkText,
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? _darkText : _mutedText,
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, color: _primary),
    );
  }

  Widget _counterValue(int value) {
    return Container(
      width: 42,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Text(
        '$value',
        style: const TextStyle(
          color: _darkText,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primary, width: 1.4),
        ),
      ),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _primary.withValues(alpha: 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Tiếp tục',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
          ),
        ),
      ),
    );
  }
}
