import 'package:flutter/material.dart';

import 'package:hotel_booking_app/controllers/auth/AuthContronller.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';

import 'package:hotel_booking_app/screens/khachhang/trangchu/trangchu_screen.dart';
import 'package:hotel_booking_app/screens/khachhang/khachhang_booking/booking_history_screen.dart';
import 'package:hotel_booking_app/screens/khachhang/luuphong/luuphong_screen.dart';
import 'package:hotel_booking_app/screens/khachhang/notification/thongbao_screen.dart';
import 'package:hotel_booking_app/screens/khachhang/taikhoan_kh/taikhoankh_screen.dart';

// Giao diện khách hàng
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final BookingService _bookingService = FirebaseBookingService();
  final Authcontronller _authController = Authcontronller();

  late final List<Widget> _screens;

  void _onTabChanged(int index) {
    if (!mounted) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    final String userId = _authController.uid ?? '';

    _screens = [
      const TrangChuScreen(),

      BookingHistoryScreen(
        service: _bookingService,
        userId: userId,
        onTabChanged: _onTabChanged,
        showBottomNav: false,
      ),

      const LuuPhongScreen(),

      const NotificationScreen(),

      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2388E8);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Đơn đặt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Đã lưu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
