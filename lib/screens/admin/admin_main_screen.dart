import 'package:flutter/material.dart';

import 'ql_danhgia_screen.dart';
import '../admin/quanly_dondatphong/ql_don_screen.dart';
import '../admin/ql_khach_screen.dart';
import 'tongquan_screen.dart';
import 'ql_phong_screen.dart';
import '../../services/phong_service.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  final List<Widget> _screens = [
    // Phòng sẽ để ở đây
    const TongQuanScreen(),
    const QLPhongScreen(),
    QuanLyKhachHangScreen(),
    QLDonDatPhongScreen(),
    ReviewScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: _screens[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Tổng quan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.meeting_room),
                  label: 'Phòng',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Khách',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Đơn',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star_rate),
                  label: 'Đánh giá',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: _buildAppBar(),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(
                    color: Colors.blueAccent,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: Colors.blueAccent,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('Tổng quan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.meeting_room),
                      label: Text('Phòng'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people),
                      label: Text('Khách'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.receipt_long),
                      label: Text('Đơn'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.star_rate),
                      label: Text('Đánh giá'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          );
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Admin Dashboard',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mở form sửa Thông tin Khách sạn'),
                ),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.business, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
