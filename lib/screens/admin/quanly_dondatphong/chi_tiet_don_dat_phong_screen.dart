import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/ServiceDetail/ServiceDetailController.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:hotel_booking_app/controllers/khachhang/notification/notificationController.dart';
import 'package:hotel_booking_app/controllers/khachhang/payment/paymentController.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/NotificationModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';
import 'package:hotel_booking_app/services/notification_service/thongbao_service.dart';
import 'package:provider/provider.dart';

class ChiTietDonDatPhongScreen extends StatefulWidget {
  final BookingModel booking;
  final RoomTypeModel? roomType;
  final String image;

  const ChiTietDonDatPhongScreen({
    super.key,
    required this.booking,
    required this.roomType,
    required this.image,
  });

  @override
  State<ChiTietDonDatPhongScreen> createState() =>
      _ChiTietDonDatPhongScreenState();
}

class _ChiTietDonDatPhongScreenState extends State<ChiTietDonDatPhongScreen> {
  late String _selectedStatus;
  late String _initialStatus;
  bool _isLoadingDetails = true;
  bool _isSaving = false;

  final AmenityController _amenityController = AmenityController();
  final BookingController _bookingController = BookingController();
  final ServiceDetailController _serviceDetailController =
      ServiceDetailController();
  final Paymentcontroller _paymentController = Paymentcontroller();

  List<Amenitymodel> _amenities = [];
  UserModel? _customer;
  List<ServiceModel> _services = [];
  Set<String> _selectedServiceIds = {};
  final Map<String, TextEditingController> _serviceQuantityControllers = {};
  double _paidAmount = 0;

  final List<String> _statuses = const [
    'Đang chờ xử lý',
    'Xác nhận',
    'Hủy',
    'Không nhận phòng',
    'Đã nhận phòng',
    'Hoàn tất',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _normalizeStatus(widget.booking.bookingStatus);
    _initialStatus = _selectedStatus;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      await _amenityController.loadAmenities();
      _amenities = List.from(_amenityController.amenities);

      await _serviceDetailController.loadServices();
      _services = List.from(_serviceDetailController.services);
      _syncServiceQuantityControllers();

      final bookingId = widget.booking.id;
      if (_selectedStatus == 'Hoàn tất' &&
          bookingId != null &&
          bookingId.isNotEmpty) {
        await _serviceDetailController.loadServiceUsedByBookingId(bookingId);
        _hydrateUsedServices();
      }

      await _loadPaidAmount();

      //cần thêm userController để lấy thông tin gián tiếp
      final userId = widget.booking.userId;
      if (userId.isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (doc.exists && doc.data() != null) {
          _customer = UserModel.fromJson(doc.data()!, doc.id);
        }
      }
    } catch (_) {
      // Keep UI usable even if auxiliary data fails to load.
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  void _hydrateUsedServices() {
    final quantityByService = <String, int>{};

    for (final detail in _serviceDetailController.serviceUsed) {
      quantityByService[detail.serviceId] =
          (quantityByService[detail.serviceId] ?? 0) + detail.quantity;
    }

    _selectedServiceIds = quantityByService.keys.toSet();

    for (final entry in quantityByService.entries) {
      final controller = _serviceQuantityControllers[entry.key];
      if (controller != null) {
        controller.text = entry.value.toString();
      }
    }
  }

  void _syncServiceQuantityControllers() {
    final validServiceIds = _services
        .map((service) => service.id)
        .whereType<String>()
        .toSet();

    final removedIds = _serviceQuantityControllers.keys
        .where((id) => !validServiceIds.contains(id))
        .toList();
    for (final id in removedIds) {
      _serviceQuantityControllers[id]?.dispose();
      _serviceQuantityControllers.remove(id);
    }

    for (final service in _services) {
      final serviceId = service.id;
      if (serviceId == null || serviceId.isEmpty) {
        continue;
      }

      _serviceQuantityControllers.putIfAbsent(
        serviceId,
        () => TextEditingController(text: '1'),
      );
    }
  }

  int _getServiceQuantity(String serviceId) {
    final controller = _serviceQuantityControllers[serviceId];
    final value = int.tryParse(controller?.text.trim() ?? '1') ?? 1;
    return value < 1 ? 1 : value;
  }

  String _normalizeStatus(String status) {
    switch (status) {
      case 'pending':
      case 'Đang chờ xử lý':
        return 'Đang chờ xử lý';
      case 'confirmed':
      case 'Xác nhận':
        return 'Xác nhận';
      case 'cancelled':
      case 'Hủy':
        return 'Hủy';
      case 'no_show':
      case 'Không nhận phòng':
        return 'Không nhận phòng';
      case 'checkin':
      case 'Đã nhận phòng':
        return 'Đã nhận phòng';
      case 'completed':
      case 'Hoàn tất':
        return 'Hoàn tất';
      default:
        return 'Đang chờ xử lý';
    }
  }

  String _statusToDatabaseValue(String status) {
    switch (status) {
      case 'Đang chờ xử lý':
        return 'pending';
      case 'Xác nhận':
        return 'confirmed';
      case 'Hủy':
        return 'cancelled';
      case 'Không nhận phòng':
        return 'no_show';
      case 'Đã nhận phòng':
        return 'checkin';
      case 'Hoàn tất':
        return 'completed';
      default:
        return 'pending';
    }
  }

  double _selectedServiceTotal() {
    return _services
        .where((service) => _selectedServiceIds.contains(service.id))
        .fold<double>(0, (sum, service) {
          final serviceId = service.id;
          if (serviceId == null) {
            return sum;
          }

          return sum + (service.price * _getServiceQuantity(serviceId));
        });
  }

  double _bookingBaseTotal() {
    return widget.booking.totalPrice ?? 0;
  }

  double _bookingTotalAfterServices() {
    return _bookingBaseTotal() + _selectedServiceTotal();
  }

  Future<String?> _askPaymentMethodForAmount(double amount) async {
    if (!mounted) return null;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn phương thức thanh toán'),
          backgroundColor: Colors.white,
          content: Text(
            'Số tiền phát sinh: ${amount.toStringAsFixed(0)} VNĐ. Chọn cách thanh toán cho phần này.',
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'TIEN_MAT'),
              child: const Text(
                'Tiền mặt',
                style: TextStyle(color: Color(0xFF0077FF)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'CHUYEN_KHOAN'),
              child: const Text(
                'Chuyển khoản',
                style: TextStyle(color: Color(0xFF0077FF)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<PaymentModel?> _createPaymentForAmount(
    String bookingId,
    double amount,
  ) async {
    if (amount <= 0) return null;

    final paymentMethod = await _askPaymentMethodForAmount(amount);
    if (paymentMethod == null) return null;

    return _paymentController.createPayment(
      bookingId,
      amount,
      paymentMethod,
      _paymentController.generateOrderCode(),
    );
  }

  Future<void> _loadPaidAmount() async {
    final bookingId = widget.booking.id;
    if (bookingId == null || bookingId.isEmpty) {
      _paidAmount = 0;
      return;
    }

    try {
      // Tính tổng tiền cần tạo payment
      final totalPrice = _selectedStatus == 'Hoàn tất'
          ? _bookingTotalAfterServices()
          : _bookingBaseTotal();

      final bookingPaymentTotal = await _paymentController
          .getTotalPaymentByBookingId(bookingId);

      if (bookingPaymentTotal <= 0) {
        debugPrint('📌 Không tìm payment cho booking $bookingId, tạo mới');
        await _createPaymentForAmount(bookingId, totalPrice);
        _paidAmount = 0;
      } else {
        final paidTotal = bookingPaymentTotal;

        if (paidTotal > 0 && paidTotal < totalPrice) {
          final remainingAmount = totalPrice - paidTotal;
          debugPrint(
            '📌 Đã có payment tổng $paidTotal, còn lại: $remainingAmount',
          );
          await _createPaymentForAmount(bookingId, remainingAmount);

          _paidAmount = paidTotal;
        } else {
          // Đã thanh toán hết hoặc chưa thanh toán
          _paidAmount = paidTotal;
        }
      }
    } catch (e) {
      debugPrint('❌ Lỗi _loadPaidAmount: $e');
      _paidAmount = 0;
    }
  }

  double _remainingBookingTotal() {
    final remaining = _bookingTotalAfterServices() - _paidAmount;
    return remaining < 0 ? 0 : remaining;
  }

  Future<void> _sendStatusNotificationToCustomer({
    required String bookingId,
    required String status,
  }) async {
    String type = 'system';
    String title = 'Cập nhật đơn đặt phòng';
    String content = 'Đơn $bookingId đã được cập nhật trạng thái: $status.';

    switch (status) {
      case 'Đang chờ xử lý':
        type = 'system';
        title = 'Đơn đặt phòng đang chờ xử lý';
        content = 'Đơn $bookingId của bạn đang chờ khách sạn xử lý.';
        break;
      case 'Xác nhận':
        type = 'booking';
        title = 'Đơn đặt phòng đã được xác nhận';
        content = 'Đơn $bookingId của bạn đã được khách sạn xác nhận.';
        break;
      case 'Hủy':
        type = 'cancel';
        title = 'Đơn đặt phòng đã bị hủy';
        content = 'Đơn $bookingId của bạn đã bị hủy.';
        break;
      case 'Không nhận phòng':
        type = 'no_show';
        title = 'Không nhận phòng';
        content = 'Đơn $bookingId được đánh dấu là không nhận phòng.';
        break;
      case 'Đã nhận phòng':
        type = 'checkIn';
        title = 'Bạn đã nhận phòng';
        content = 'Đơn $bookingId đã chuyển sang trạng thái đã nhận phòng.';
        break;
      case 'Hoàn tất':
        type = 'complete';
        title = 'Đơn đặt phòng đã hoàn tất';
        content = 'Cảm ơn bạn đã sử dụng dịch vụ. Đơn $bookingId đã hoàn tất.';
        break;
    }

    // Always create a new notification document for each status update.
    final notification = NotificationModel(
      userId: widget.booking.userId,
      bookingId: bookingId,
      title: title,
      content: content,
      type: type,
    );
    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification.toJson());

    //  notification
    final notificationController = context.read<NotificationController>();

    if (status == 'Xác nhận') {
      notificationController.sendConfirmNotification(bookingId);
    } else if (status == 'Hủy') {
      notificationController.sendCancelNotification(bookingId);
    } else if (status == 'Đã nhận phòng') {
      notificationController.sendCheckInNotification(bookingId);
    } else if (status == 'Hoàn tất') {
      notificationController.sendCompleteNotification(bookingId);
    }
  }

  @override
  void dispose() {
    for (final controller in _serviceQuantityControllers.values) {
      controller.dispose();
    }
    _paymentController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Xác nhận':
        return Colors.orange;
      case 'Hủy':
        return Colors.red;
      case 'Không nhận phòng':
        return Colors.deepOrange;
      case 'Đã nhận phòng':
        return Colors.purple;
      case 'Hoàn tất':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn đặt phòng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0077FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: widget.image.startsWith('http')
                  ? Image.network(
                      widget.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Thông tin phòng'),
            _buildInfoRow('Mã loại phòng:', widget.booking.roomTypeId),
            _buildInfoRow(
              'Tên phòng:',
              widget.roomType?.roomTypeName ?? 'Không có dữ liệu',
            ),
            if (widget.roomType != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Giá phòng:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.roomType!.pricePerNight.toStringAsFixed(0)} VNĐ/đêm',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              _buildInfoRow('Giá phòng:', 'Không có dữ liệu'),
            _buildInfoRow(
              'Tiện ích:',
              widget.roomType == null || widget.roomType!.amensIds.isEmpty
                  ? 'Không có dữ liệu'
                  : _amenities.isNotEmpty
                  ? _amenities.map((a) => a.amenityName).join(', ')
                  : 'Đang tải...',
            ),
            _buildInfoRow(
              'Mô tả:',
              widget.roomType?.description ?? 'Không có dữ liệu',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Thông tin khách đặt'),
            _buildInfoRow(
              'Họ và tên:',
              _customer?.fullName ?? 'Không có dữ liệu',
            ),
            _buildInfoRow('Email:', _customer?.email ?? 'Không có dữ liệu'),
            _buildInfoRow(
              'Số điện thoại:',
              _customer?.phoneNumber ?? 'Không có dữ liệu',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Thông tin đơn'),
            _buildInfoRow(
              'Số lượng phòng:',
              widget.booking.quantity.toString(),
            ),
            _buildInfoRow('Số lượng khách:', widget.booking.guests.toString()),
            _buildInfoRow(
              'Ngày nhận phòng:',
              _formatDate(widget.booking.checkIn),
            ),
            _buildInfoRow(
              'Ngày trả phòng:',
              _formatDate(widget.booking.checkout),
            ),
            Row(
              children: [
                const Text('Trạng thái đơn: '),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        items: _statuses.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: _getStatusColor(value)),
                            ),
                          );
                        }).toList(),
                        onChanged: _initialStatus == 'Hủy'
                            ? null
                            : (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedStatus = newValue;
                                  });
                                }
                              },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedStatus == 'Hoàn tất' && _initialStatus != 'Hủy')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle('Sử dụng dịch vụ'),
                  if (_initialStatus == 'Hoàn tất')
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Đơn đã hoàn tất nên không thể chỉnh sửa dịch vụ.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _services.isEmpty
                      ? const Text('Không có dịch vụ nào')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _services.length,
                          itemBuilder: (context, index) {
                            final service = _services[index];
                            final serviceId = service.id;
                            if (serviceId == null || serviceId.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            final isSelected = _selectedServiceIds.contains(
                              serviceId,
                            );
                            final quantityController =
                                _serviceQuantityControllers[serviceId];
                            final isServiceEditable =
                                _initialStatus != 'Hoàn tất';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    activeColor: const Color(0xFF0077FF),
                                    checkColor: Colors.white,
                                    onChanged: isServiceEditable
                                        ? (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedServiceIds.add(serviceId);
                                          quantityController?.text =
                                              quantityController.text.isEmpty
                                              ? '1'
                                              : quantityController.text;
                                        } else {
                                          _selectedServiceIds.remove(serviceId);
                                        }
                                      });
                                        }
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.serviceName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${service.price.toStringAsFixed(0)} VNĐ',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 90,
                                    child: TextField(
                                      controller: quantityController,
                                      enabled: isSelected && isServiceEditable,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        labelText: 'SL',
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          return;
                                        }

                                        final parsedValue = int.tryParse(value);
                                        if (parsedValue == null ||
                                            parsedValue < 1) {
                                          quantityController?.text = '1';
                                          quantityController?.selection =
                                              TextSelection.fromPosition(
                                                const TextPosition(offset: 1),
                                              );
                                          return;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF0077FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng tiền phòng: ${_bookingBaseTotal().toStringAsFixed(0)} VNĐ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tiền dịch vụ cộng thêm: ${_selectedServiceTotal().toStringAsFixed(0)} VNĐ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (_paidAmount > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Đã thanh toán: -${_paidAmount.toStringAsFixed(0)} VNĐ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                        const Divider(height: 16),
                        Text(
                          'Tổng tiền: ${_remainingBookingTotal().toStringAsFixed(0)} VNĐ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed:
                    (_initialStatus == 'Hủy' ||
                        _initialStatus == 'Hoàn tất' ||
                        _initialStatus == 'Không nhận phòng' ||
                        _isSaving)
                    ? null
                    : () async {
                        final bookingId = widget.booking.id;
                        if (bookingId == null || bookingId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Không tìm thấy mã đơn để cập nhật.',
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isSaving = true;
                        });

                        try {
                          if (_selectedStatus == 'Hoàn tất' &&
                              _selectedServiceIds.isNotEmpty) {
                            final selectedServiceQuantities = <String, int>{
                              for (final serviceId in _selectedServiceIds)
                                serviceId: _getServiceQuantity(serviceId),
                            };

                            await _serviceDetailController.saveServiceUsedItems(
                              bookingId: bookingId,
                              serviceQuantities: selectedServiceQuantities,
                            );

                            final additionalAmount = _selectedServiceTotal();
                            if (additionalAmount > 0) {
                              await _createPaymentForAmount(
                                bookingId,
                                additionalAmount,
                              );
                            }
                          }

                          await _bookingController.updateBookingStatus(
                            bookingId,
                            _statusToDatabaseValue(_selectedStatus),
                          );

                          await _sendStatusNotificationToCustomer(
                            bookingId: bookingId,
                            status: _selectedStatus,
                          );

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật trạng thái thành công!'),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cập nhật thất bại: $e')),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSaving = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077FF),
                ),
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
