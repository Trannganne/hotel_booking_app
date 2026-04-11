import 'package:flutter/material.dart';

// Import các màn hình con
import 'trangchu_screen.dart';
import 'thongbao_screen.dart';
import 'taikhoankh_screen.dart';
// Màn hình test
import 'danhgia_screen.dart';
import 'thanhtoan_screen.dart';

// Màn hình admin ( khi gộp thì nhớ xóa nha)
import '../admin/ql_danhgia_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = const [
    RatingScreen(),
    ThanhToanScreen(),
    ReviewScreen(),
    NotificationScreen(),
  ];

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
