import 'package:flutter/material.dart';

// Import các màn hình con
import '../khachhang/trangchu/trangchu_screen.dart';
// Màn hình test
import 'ql_danhgia_screen.dart';
import '../admin/quanly_dondatphong/ql_don_screen.dart';

// Màn hình admin ( khi gộp thì nhớ xóa nha)
import '../admin/ql_khach_screen.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = const [
    TrangChuScreen(),
    QuanLyKhachHangScreen(),
    QLDonDatPhongScreen(),
    ReviewScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.room), label: 'Phòng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Khách'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Đơn đặt'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Đánh giá'),
        ],
      ),
    );
  }
}
