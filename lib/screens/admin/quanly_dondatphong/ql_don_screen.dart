import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';
import 'chi_tiet_don_dat_phong_screen.dart';

class QLDonDatPhongScreen extends StatefulWidget {
  const QLDonDatPhongScreen({super.key});

  @override
  State<QLDonDatPhongScreen> createState() => _QLDonDatPhongScreenState();
}

class _QLDonDatPhongScreenState extends State<QLDonDatPhongScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingService _bookingService = FirebaseBookingService();
  final RoomTypeController _roomTypeController = RoomTypeController();
  final Color _mainColor = const Color(0xFF0077FF);

  final List<String> _statusTabs = const [
    'Tất cả',
    'Đang chờ xử lý',
    'Xác nhận',
    'Hủy',
    'Không nhận phòng',
    'Đã nhận phòng',
    'Hoàn tất',
  ];

  final List<String> _statusOrder = const [
    'Đang chờ xử lý',
    'Xác nhận',
    'Hủy',
    'Không nhận phòng',
    'Đã nhận phòng',
    'Hoàn tất',
  ];

  final List<BookingModel> _bookings = [];
  final List<RoomTypeModel> _roomTypes = [];

  bool _isLoading = false;
  String _selectedRoomTypeId = 'all';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _roomTypeController.loadRooms(),
      ]);

      final bookings = await _bookingService.getAllBookings();

      if (!mounted) return;

      setState(() {
        _roomTypes
          ..clear()
          ..addAll(_roomTypeController.rooms);
        _bookings
          ..clear()
          ..addAll(bookings);
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  RoomTypeModel? _roomTypeById(String id) {
    try {
      return _roomTypes.firstWhere((room) => room.id == id);
    } catch (_) {
      return null;
    }
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
        return 'Xác nhận';
    }
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

  bool _matchesFilters(BookingModel booking) {
    if (_selectedRoomTypeId != 'all' && booking.roomTypeId != _selectedRoomTypeId) {
      return false;
    }

    final bookingDate = booking.createdAt ?? booking.checkIn;
    final startDate = _startDate;
    final endDate = _endDate;
    final bookingDay = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

    if (startDate != null) {
      final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
      if (bookingDay.isBefore(normalizedStart)) {
        return false;
      }
    }

    if (endDate != null) {
      final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
      if (bookingDay.isAfter(normalizedEnd)) {
        return false;
      }
    }

    return true;
  }

  List<BookingModel> _filteredBookings() {
    final filtered = _bookings.where((booking) {
      return _matchesFilters(booking);
    }).toList();

    filtered.sort((a, b) {
      final statusA = _statusOrder.indexOf(_normalizeStatus(a.bookingStatus));
      final statusB = _statusOrder.indexOf(_normalizeStatus(b.bookingStatus));
      if (statusA != statusB) {
        return statusA.compareTo(statusB);
      }
      final dateA = a.createdAt ?? a.checkIn;
      final dateB = b.createdAt ?? b.checkIn;
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  Future<void> _openFilterDialog() async {
    DateTime? tempStart = _startDate;
    DateTime? tempEnd = _endDate;
    String tempRoomTypeId = _selectedRoomTypeId;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Bộ lọc đơn đặt phòng', style: TextStyle(color: _mainColor)),
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              Future<void> pickStartDate() async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: tempStart ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: _mainColor,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child ?? const SizedBox(),
                    );
                  },
                );
                if (picked != null) {
                  setDialogState(() {
                    tempStart = picked;
                    if (tempEnd != null && tempEnd!.isBefore(picked)) {
                      tempEnd = picked;
                    }
                  });
                }
              }

              Future<void> pickEndDate() async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: tempEnd ?? (tempStart ?? DateTime.now()),
                  firstDate: tempStart ?? DateTime(2020),
                  lastDate: DateTime(2100),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: _mainColor,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child ?? const SizedBox(),
                    );
                  },
                );
                if (picked != null) {
                  setDialogState(() {
                    tempEnd = picked;
                  });
                }
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: tempRoomTypeId,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(labelText: 'Loại phòng', labelStyle: TextStyle(color: _mainColor)),
                      items: [
                        const DropdownMenuItem(
                          value: 'all',
                          child: Text('Tất cả loại phòng'),
                        ),
                        ..._roomTypes.map(
                          (roomType) => DropdownMenuItem(
                            value: roomType.id,
                            child: Text(roomType.roomTypeName),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            tempRoomTypeId = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Từ ngày đặt', style: TextStyle(color: _mainColor)),
                      subtitle: Text(
                        tempStart == null
                            ? 'Chưa chọn'
                            : '${tempStart!.day.toString().padLeft(2, '0')}/${tempStart!.month.toString().padLeft(2, '0')}/${tempStart!.year}',
                      ),
                      trailing: TextButton(
                        onPressed: pickStartDate,
                        child: const Text('Chọn', style: TextStyle(color: Colors.black),),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Đến ngày đặt', style: TextStyle(color: _mainColor)),
                      subtitle: Text(
                        tempEnd == null
                            ? 'Chưa chọn'
                            : '${tempEnd!.day.toString().padLeft(2, '0')}/${tempEnd!.month.toString().padLeft(2, '0')}/${tempEnd!.year}',
                      ),
                      trailing: TextButton(
                        onPressed: pickEndDate,
                        child: const Text('Chọn', style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedRoomTypeId = 'all';
                  _startDate = null;
                  _endDate = null;
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Xóa lọc', style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedRoomTypeId = tempRoomTypeId;
                  _startDate = tempStart;
                  _endDate = tempEnd;
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Áp dụng', style: TextStyle(color: Color(0xFF007AFF))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Quản lý đơn đặt phòng',
        showBackButton: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabAlignment: TabAlignment.start,
          tabs: _statusTabs.map((status) => Tab(text: status)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_selectedRoomTypeId != 'all')
                        Chip(
                          label: Text(
                            _roomTypeById(_selectedRoomTypeId)?.roomTypeName ?? 'Loại phòng',
                            style: TextStyle(color: _mainColor),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: _mainColor.withOpacity(0.15)),
                        ),
                      if (_startDate != null)
                        Chip(
                          label: Text(
                            'Từ ${_startDate!.day.toString().padLeft(2, '0')}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.year}',
                            style: TextStyle(color: _mainColor),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: _mainColor.withOpacity(0.15)),
                        ),
                      if (_endDate != null)
                        Chip(
                          label: Text(
                            'Đến ${_endDate!.day.toString().padLeft(2, '0')}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.year}',
                            style: TextStyle(color: _mainColor),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: _mainColor.withOpacity(0.15)),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: _openFilterDialog,
                  icon: const Icon(Icons.filter_alt),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: _statusTabs.map((status) {
                      return _buildBookingList(status);
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String status) {
    final bookings = _filteredBookings().where((booking) {
      if (status == 'Tất cả') {
        return true;
      }
      return _normalizeStatus(booking.bookingStatus) == status;
    }).toList();

    if (bookings.isEmpty) {
      return const Center(
        child: Text('Không có đơn đặt phòng phù hợp'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final roomType = _roomTypeById(booking.roomTypeId);
          final normalizedStatus = _normalizeStatus(booking.bookingStatus);
          final imagePath = roomType?.imagesList.isNotEmpty == true
              ? roomType!.imagesList.first
              : 'assets/images/phong01_01.jpg';
          final bookingDate = booking.createdAt ?? booking.checkIn;
          final dateText =
              '${bookingDate.day.toString().padLeft(2, '0')}/${bookingDate.month.toString().padLeft(2, '0')}/${bookingDate.year}';

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.all(8.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChiTietDonDatPhongScreen(
                    booking: booking,
                    roomType: roomType,
                    image: imagePath,
                  ),
                ),
              );
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    imagePath.startsWith('http')
                        ? Image.network(
                            imagePath,
                            width: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 120,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image),
                            ),
                          )
                        : Image.asset(
                            imagePath,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              roomType?.roomTypeName ?? 'Phòng ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            ),
                          const SizedBox(height: 4),
                            Text('Mã booking: ${booking.id ?? '-'}'),
                            Text('Loại phòng: ${roomType?.roomTypeName ?? booking.roomTypeId}'),
                            Text('Ngày đặt: $dateText'),
                            Text('Trạng thái: $normalizedStatus'),
                          const Spacer(),
                            badges.Badge(
                              badgeContent: Text(
                                normalizedStatus,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              badgeStyle: badges.BadgeStyle(
                                shape: badges.BadgeShape.square,
                                badgeColor: _getStatusColor(normalizedStatus),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          )
            );
          },
        ),
      );
    }
  }
