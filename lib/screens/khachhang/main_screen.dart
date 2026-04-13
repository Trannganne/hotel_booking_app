import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

import 'package:flutter/material.dart';

// Import các màn hình con
import '../khachhang/trangchu/trangchu_screen.dart';
import 'thongbao_screen.dart';
import 'taikhoankh_screen.dart';
import '../khachhang/khachhang_booking/booking_history_screen.dart';
import '../khachhang/khachhang_booking/booking_customer_root_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 1. Khởi tạo đối tượng service thực tế
  final BookingFlowService _bookingService = BookingFlowService();

  // 2. Định nghĩa hàm xử lý khi tab thay đổi (nếu cần)
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late List<Widget> _screens;

  // Danh sách các màn hình
  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách màn hình ở đây
    _screens = [
      const TrangChuScreen(),
      BookingHistoryScreen(
        service: _bookingService, // Truyền đối tượng đã khởi tạo
        onTabChanged: _onTabChanged,
        showBottomNav:
            false, // Tắt BottomNav riêng của nó để dùng của MainScreen
      ),
      //const ProfileScreen(), đã lưu
      const NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Đơn đặt'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Đã lưu',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
