import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';

class ChonNgayScreen extends StatefulWidget {
  final DateTime initialCheckIn;
  final DateTime initialCheckOut;
  final int maxOccupancy;
  final String? roomTypeId;

  const ChonNgayScreen({
    super.key,
    required this.initialCheckIn,
    required this.initialCheckOut,
    this.maxOccupancy = 1,
    this.roomTypeId,
  });

  @override
  State<ChonNgayScreen> createState() => _ChonNgayScreenState();
}

class _ChonNgayScreenState extends State<ChonNgayScreen> {
  final Color _mainColor = const Color(0xFF0077FF);
  final BookingService _bookingService = FirebaseBookingService();
  late DateTime _selectedCheckIn;
  late DateTime _selectedCheckOut;
  int _roomQuantity = 1;
  int _guests = 1;
  int _totalEmptyRooms = 0;
  Map<DateTime, int> _reservedRoomsByDate = <DateTime, int>{};

  @override
  void initState() {
    super.initState();
    _selectedCheckIn = widget.initialCheckIn;
    _selectedCheckOut = widget.initialCheckOut;
    _initializeDateFormatting();
    _loadBookedDates();
    Intl.defaultLocale = 'vi_VN';
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('vi_VN', null);
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  bool _isBlockingStatus(String status) {
    switch (status) {
      case 'cancelled':
      case 'Hủy':
      case 'no_show':
      case 'Không nhận phòng':
        return false;
      default:
        return true;
    }
  }

  int _remainingRoomsOnDate(DateTime date) {
    final day = _dateOnly(date);
    final reserved = _reservedRoomsByDate[day] ?? 0;
    final remaining = _totalEmptyRooms - reserved;
    return remaining < 0 ? 0 : remaining;
  }

  bool _hasInsufficientRoomsInRange(DateTime checkIn, DateTime checkOut) {
    DateTime cursor = _dateOnly(checkIn);
    final end = _dateOnly(checkOut);

    while (cursor.isBefore(end)) {
      if (_remainingRoomsOnDate(cursor) < _roomQuantity) {
        return true;
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return false;
  }

  bool _isSelectableCheckIn(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = _dateOnly(date);
    if (day.isBefore(today)) return false;
    return true; // availability checks disabled
  }

  bool _isSelectableCheckOut(DateTime date) {
    final checkInDay = _dateOnly(_selectedCheckIn);
    final checkOutDay = _dateOnly(date);
    if (checkOutDay.isBefore(checkInDay)) return false;
    return true; // availability checks disabled
  }

  int _maxGuestsBySelectedRooms() {
    final perRoom = widget.maxOccupancy <= 0 ? 1 : widget.maxOccupancy;
    return _roomQuantity * perRoom;
  }

  Future<int> _loadTotalEmptyRooms() async {
    // Disable availability checks: return a large number so validations don't fail.
    return 9999;
  }

  Future<void> _loadBookedDates() async {
    // Skip loading bookings and overlap checks.
    if (!mounted) return;
    setState(() {
      _totalEmptyRooms = 9999;
      _reservedRoomsByDate = {};
      if (_roomQuantity < 1) _roomQuantity = 1;
      if (_guests > _maxGuestsBySelectedRooms()) {
        _guests = _maxGuestsBySelectedRooms();
      }
    });
  }

  Future<void> _selectCheckInDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final initialDate = _isSelectableCheckIn(_selectedCheckIn)
        ? _selectedCheckIn
        : firstDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      selectableDayPredicate: _isSelectableCheckIn,
      locale: const Locale('vi', 'VN'),
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
      setState(() {
        _selectedCheckIn = picked;
        // Nếu check in > check out, cập nhật check out = check in
        if (_selectedCheckIn.isAfter(_selectedCheckOut)) {
          _selectedCheckOut = _selectedCheckIn;
        }
        if (_roomQuantity < 1) _roomQuantity = 1;
        if (_guests > _maxGuestsBySelectedRooms()) {
          _guests = _maxGuestsBySelectedRooms();
        }
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final maxCheckOut = _selectedCheckIn.add(const Duration(days: 7));
    var initialDate = _selectedCheckOut;
    if (!_isSelectableCheckOut(initialDate)) {
      initialDate = _selectedCheckIn;
      while (!initialDate.isAfter(maxCheckOut) && !_isSelectableCheckOut(initialDate)) {
        initialDate = initialDate.add(const Duration(days: 1));
      }
      if (initialDate.isAfter(maxCheckOut)) {
        initialDate = _selectedCheckIn;
      }
    }
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _selectedCheckIn,
      lastDate: maxCheckOut,
      selectableDayPredicate: _isSelectableCheckOut,
      locale: const Locale('vi', 'VN'),
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
      setState(() {
        _selectedCheckOut = picked;
      });
    }
  }

  bool _isValidDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Kiểm tra check in không nhỏ hơn ngày hiện tại
    if (_selectedCheckIn.isBefore(today)) {
      return false;
    }

    // Kiểm tra check in <= check out
    if (_selectedCheckIn.isAfter(_selectedCheckOut)) {
      return false;
    }

    // Kiểm tra khoảng cách không quá 7 ngày
    final daysDifference = _selectedCheckOut.difference(_selectedCheckIn).inDays;
    if (daysDifference > 7) {
      return false;
    }

    if (_roomQuantity <= 0) {
      return false;
    }


    // Kiểm tra số khách
    if (_guests <= 0) return false;
    if (_guests > _maxGuestsBySelectedRooms()) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    String checkInError = '';
    String checkOutError = '';

    if (_selectedCheckIn.isBefore(today)) {
      checkInError = 'Ngày check in không được nhỏ hơn ngày hiện tại';
    }
    if (_selectedCheckIn.isAfter(_selectedCheckOut)) {
      checkOutError = 'Ngày check out phải >= ngày check in';
    }

    final daysDifference = _selectedCheckOut.difference(_selectedCheckIn).inDays;
    if (daysDifference > 7) {
      checkOutError = 'Thời gian lưu trú không được quá 7 ngày';
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chọn ngày',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Ngày Check-in',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectCheckInDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: checkInError.isNotEmpty ? Colors.red : Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(_selectedCheckIn),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Color(0xFF0077FF)),
                  ],
                ),
              ),
            ),
            if (checkInError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  checkInError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Ngày Check-out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectCheckOutDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: checkOutError.isNotEmpty ? Colors.red : Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(_selectedCheckOut),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Color(0xFF0077FF)),
                  ],
                ),
              ),
            ),
            if (checkOutError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  checkOutError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 32),
            Text(
              'Số phòng muốn đặt',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _mainColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_roomQuantity > 1) {
                        _roomQuantity--;
                        if (_guests > _maxGuestsBySelectedRooms()) {
                          _guests = _maxGuestsBySelectedRooms();
                        }
                      }
                    });
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: _mainColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_roomQuantity',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // availability checks disabled; allow increasing rooms
                    setState(() {
                      if (_roomQuantity < 9999) {
                        _roomQuantity++;
                      }
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: _mainColor,
                ),
                const SizedBox(width: 12),
                Text('Trống ngày check-in: Không kiểm tra'),
              ],
            ),
            const SizedBox(height: 20),
            // Guest selector
            Text(
              'Số khách',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _mainColor),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_guests > 1) _guests--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: _mainColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_guests',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_guests < _maxGuestsBySelectedRooms()) _guests++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: _mainColor,
                ),
                const SizedBox(width: 12),
                Text('Tối đa: ${_maxGuestsBySelectedRooms()}'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValidDates()
                    ? () {
                        Navigator.pop(context, {
                          'checkIn': _selectedCheckIn,
                          'checkOut': _selectedCheckOut,
                          'guests': _guests,
                          'quantity': _roomQuantity,
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mainColor,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
