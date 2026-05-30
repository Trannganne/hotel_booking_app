import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/screens/admin/tongquan/tongquan_screen.dart';
import 'package:hotel_booking_app/screens/admin/ql_phong/phong/ql_phong_screen.dart';

import 'ql_danhgia/ql_danhgia_screen.dart';
import '../admin/quanly_dondatphong/ql_don_screen.dart';
import 'ql_khach/ql_khach_screen.dart';
import 'tongquan/tongquan_screen.dart';
import 'ql_khachsan/thong_tin_khach_san_screen.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:hotel_booking_app/screens/khachhang/auth/dangnhap_screen.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({Key? key}) : super(key: key);

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TongQuanScreen(),
    QLPhongScreen(),
    QuanLyKhachHangScreen(),
    QLDonDatPhongScreen(),
    ReviewScreen(),
    ThongTinKhachSanScreen(),
  ];

  // Xử lý đăng xuất
  Future<void> _dangXuat(BuildContext context) async {
    final authService = AuthService();

    await authService.dangXuat();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DangNhapScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 10,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Khách sạn',
          ),
        ],
      ),
    );
  }
}
