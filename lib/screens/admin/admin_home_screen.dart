import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../khachhang/dangnhap_screen.dart';
import 'ql_khach_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> _dangXuat(BuildContext context) async {
    final authService = AuthService();

    await authService.dangXuat();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const DangNhapScreen(),
      ),
      (route) => false,
    );
  }

  void _moManHinhQuanLyKhach(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QuanLyKhachHangScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text(
          'Trang quản trị',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: () => _dangXuat(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _AdminMenuCard(
              icon: Icons.people_outline,
              title: 'Quản lý khách hàng',
              onTap: () => _moManHinhQuanLyKhach(context),
            ),
            _AdminMenuCard(
              icon: Icons.hotel_outlined,
              title: 'Quản lý khách sạn',
              onTap: () {},
            ),
            _AdminMenuCard(
              icon: Icons.meeting_room_outlined,
              title: 'Quản lý phòng',
              onTap: () {},
            ),
            _AdminMenuCard(
              icon: Icons.receipt_long_outlined,
              title: 'Quản lý đặt phòng',
              onTap: () {},
            ),
            _AdminMenuCard(
              icon: Icons.payments_outlined,
              title: 'Quản lý thanh toán',
              onTap: () {},
            ),
            _AdminMenuCard(
              icon: Icons.bar_chart_outlined,
              title: 'Thống kê',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 42,
                color: primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF26456E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}