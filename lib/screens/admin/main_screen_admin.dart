import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/admin/ql_phong/phong/ql_phong_screen.dart';

// Import các màn hình con

import 'ql_danhgia/ql_danhgia_screen.dart';
import '../admin/quanly_dondatphong/ql_don_screen.dart';
import 'ql_khach/ql_khach_screen.dart';
import 'tongquan/tongquan_screen.dart';
import 'ql_phong/loaiphong/ql_loaiphong_screen.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = const [
    const TongQuanScreen(),
    //const RoomTypeScreen(),
    QLPhongScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: 'Phòng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Khách'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Đơn đặt'),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rate),
            label: 'Đánh giá',
          ),
        ],
      ),
    );
  }
}
