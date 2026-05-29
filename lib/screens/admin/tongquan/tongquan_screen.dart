import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';
import 'package:hotel_booking_app/services/payment_service/thanhtoan_service.dart';
import 'package:hotel_booking_app/services/room_service/room_service.dart';

class TongQuanScreen extends StatefulWidget {
  const TongQuanScreen({Key? key}) : super(key: key);

  @override
  State<TongQuanScreen> createState() => _TongQuanScreenState();
}

class _TongQuanScreenState extends State<TongQuanScreen> {
  final PhongService _roomService = PhongService();
  final BookingService _bookingService = FirebaseBookingService();
  final PaymentService _paymentService = PaymentService();

  bool _isLoading = true;
  String? _errorMessage;

  List<RoomModel> _rooms = [];
  List<BookingModel> _bookings = [];
  List<PaymentModel> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rooms = await _roomService.getAllRooms();
      final bookings = await _bookingService.getAllBookings();
      final payments = await _paymentService.getAll();

      if (!mounted) return;

      setState(() {
        _rooms = rooms.where((room) => room.isDeleted == false).toList();
        _bookings = bookings;
        _payments = payments;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Lỗi tải dữ liệu tổng quan: $e';
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(value);
  }

  String _formatShortCurrency(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} Tỷ';
    }

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} Triệu';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}nghìn';
    }

    return value.toStringAsFixed(0);
  }

  bool _isPaidPayment(PaymentModel payment) {
    final status = payment.status.toString().toLowerCase().trim();

    return status == 'paid' ||
        status == 'paided' ||
        status == 'success' ||
        status == 'completed' ||
        status == 'done' ||
        status == 'đã thanh toán' ||
        status == 'da thanh toan';
  }

  bool get _hasPaidPayments {
    return _payments.any(_isPaidPayment);
  }

  List<PaymentModel> get _validRevenuePayments {
    if (_hasPaidPayments) {
      return _payments.where(_isPaidPayment).toList();
    }

    return _payments;
  }

  double get _totalRevenue {
    return _validRevenuePayments.fold<double>(
      0,
      (sum, payment) => sum + payment.totalPrice,
    );
  }

  int get _totalRooms => _rooms.length;

  int get _availableRooms {
    return _rooms.where((room) => room.status == RoomStatus.available).length;
  }

  int get _maintenanceOrLockedRooms {
    return _rooms.where((room) {
      return room.status == RoomStatus.maintenance ||
          room.status == RoomStatus.locked;
    }).length;
  }

  int get _totalBookings => _bookings.length;

  int get _pendingBookings {
    return _bookings.where((booking) {
      final status = booking.bookingStatus.toLowerCase().trim();

      return status == 'pending' ||
          status == 'waiting' ||
          status == 'đang chờ xử lý' ||
          status == 'chờ duyệt' ||
          status == 'cho duyet';
    }).length;
  }

  int get _confirmedBookings {
    return _bookings.where((booking) {
      final status = booking.bookingStatus.toLowerCase().trim();

      return status == 'confirmed' ||
          status == 'approved' ||
          status == 'xác nhận' ||
          status == 'xac nhan' ||
          status == 'đã duyệt' ||
          status == 'da duyet' ||
          status == 'hoàn tất' ||
          status == 'hoan tat';
    }).length;
  }

  int get _cancelledBookings {
    return _bookings.where((booking) {
      final status = booking.bookingStatus.toLowerCase().trim();

      return status == 'cancelled' ||
          status == 'canceled' ||
          status == 'hủy' ||
          status == 'huy' ||
          status == 'đã hủy' ||
          status == 'da huy' ||
          status == 'không nhận phòng' ||
          status == 'khong nhan phong';
    }).length;
  }

  DateTime _dateForBooking(BookingModel booking) {
    return booking.createdAt ?? booking.checkIn;
  }

  List<DateTime> get _lastFourMonths {
    final now = DateTime.now();

    return List.generate(4, (index) {
      return DateTime(now.year, now.month - 3 + index, 1);
    });
  }

  List<String> get _lastFourMonthLabels {
    return _lastFourMonths.map((date) => 'T${date.month}').toList();
  }

  double _bookingRevenueInMonth(DateTime month) {
    double total = 0;

    for (final booking in _bookings) {
      final date = _dateForBooking(booking);

      if (date.year == month.year && date.month == month.month) {
        total += booking.totalPrice ?? 0;
      }
    }

    return total;
  }

  double _paymentRevenueInMonth(DateTime month) {
    double total = 0;

    for (final payment in _validRevenuePayments) {
      final matchedBookings = _bookings.where((booking) {
        return booking.id == payment.bookingId;
      }).toList();

      DateTime date;

      if (matchedBookings.isNotEmpty) {
        date = _dateForBooking(matchedBookings.first);
      } else {
        date = DateTime.now();
      }

      if (date.year == month.year && date.month == month.month) {
        total += payment.totalPrice;
      }
    }

    return total;
  }

  List<double> get _monthlyPaymentRevenue {
    return _lastFourMonths.map(_paymentRevenueInMonth).toList();
  }

  List<double> get _monthlyBookingRevenue {
    return _lastFourMonths.map(_bookingRevenueInMonth).toList();
  }

  List<Map<String, String>> get _top5Data {
    final activeRooms = _rooms
        .where((room) => room.isDeleted == false)
        .toList();

    return [
      {
        'rank': '1',
        'name': 'Tổng số phòng đang quản lý',
        'revenue': '${activeRooms.length}',
      },
      {'rank': '2', 'name': 'Phòng đang trống', 'revenue': '$_availableRooms'},
      {
        'rank': '3',
        'name': 'Phòng bảo trì / khóa',
        'revenue': '$_maintenanceOrLockedRooms',
      },
      {'rank': '4', 'name': 'Tổng đơn đặt phòng', 'revenue': '$_totalBookings'},
      {
        'rank': '5',
        'name': 'Tổng doanh thu',
        'revenue': _formatCurrency(_totalRevenue),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "TRUNG TÂM THỐNG KÊ",
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorView()
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTopStatCard(
                            'TỔNG SỐ KHÁCH SẠN',
                            '1',
                            'Đang hoạt động',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTopStatCard(
                            'Tổng số phòng',
                            _totalRooms.toString(),
                            'Trống: $_availableRooms',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTopStatCard(
                            'TỔNG DOANH THU',
                            _formatShortCurrency(_totalRevenue),
                            'Payments',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildSectionCard(
                      title: 'DOANH THU THEO THÁNG (4 THÁNG QUA)',
                      child: _buildBarChart(),
                    ),

                    const SizedBox(height: 12),

                    _buildSectionCard(
                      title: 'TỔNG ĐƠN ĐẶT THEO TRẠNG THÁI',
                      child: _buildPieChart(),
                    ),

                    const SizedBox(height: 12),

                    _buildSectionCard(
                      title: 'TOP 5 THỐNG KÊ HỆ THỐNG',
                      child: _buildTop5List(),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStatCard(String title, String value, String percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($percentage)',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final paymentRevenue = _monthlyPaymentRevenue;
    final bookingRevenue = _monthlyBookingRevenue;
    final labels = _lastFourMonthLabels;

    final allValues = [...paymentRevenue, ...bookingRevenue];

    final maxValue = allValues.isEmpty
        ? 1000.0
        : allValues.reduce((a, b) => a > b ? a : b);

    final maxY = maxValue <= 0 ? 1000.0 : maxValue * 1.25;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(fontSize: 10);
                  final index = value.toInt();

                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    meta: meta,
                    child: Text(labels[index], style: style),
                  );
                },
                reservedSize: 22,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatShortCurrency(value),
                    style: const TextStyle(fontSize: 9),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5,
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(4, (index) {
            return _makeGroupData(
              index,
              paymentRevenue[index],
              bookingRevenue[index],
            );
          }),
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF4A90E2),
          width: 14,
          borderRadius: BorderRadius.zero,
        ),
        BarChartRodData(
          toY: y2,
          color: const Color(0xFF5A6270),
          width: 14,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final pending = _pendingBookings.toDouble();
    final confirmed = _confirmedBookings.toDouble();
    final cancelled = _cancelledBookings.toDouble();

    final total = pending + confirmed + cancelled;

    final safePending = total == 0 ? 1.0 : pending;
    final safeConfirmed = total == 0 ? 1.0 : confirmed;
    final safeCancelled = total == 0 ? 1.0 : cancelled;

    return SizedBox(
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF4A90E2),
                    value: safePending,
                    title: '',
                    radius: 40,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFE24A4A),
                    value: safeConfirmed,
                    title: '',
                    radius: 40,
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFF5A623),
                    value: safeCancelled,
                    title: '',
                    radius: 40,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  const Color(0xFF4A90E2),
                  'Chờ: $_pendingBookings',
                ),
                const SizedBox(height: 8),
                _buildLegendItem(
                  const Color(0xFFE24A4A),
                  'Duyệt: $_confirmedBookings',
                ),
                const SizedBox(height: 8),
                _buildLegendItem(
                  const Color(0xFFF5A623),
                  'Hủy: $_cancelledBookings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTop5List() {
    final top5Data = _top5Data;

    return Column(
      children: top5Data.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;

        return Container(
          color: index.isEven ? const Color(0xFFF2F6F9) : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  data['rank']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  data['name']!,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Text(
                data['revenue']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
