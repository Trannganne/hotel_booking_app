import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/khachhang/trangchu/trangchu_screen.dart';

class LuuPhongScreen extends StatefulWidget {
  const LuuPhongScreen({super.key});

  @override
  State<LuuPhongScreen> createState() => _LuuPhongScreenState();
}

class _LuuPhongScreenState extends State<LuuPhongScreen> {
  final List<Map<String, dynamic>> _savedRooms = [
    {
      'id': 'P001',
      'name': 'Phòng Suite',
      'price': 328734,
      'rating': 4.5,
      'image': 'assets/images/phong01_01.jpg',
      'images': [
        'assets/images/phong01_01.jpg',
        'assets/images/phong01_02.jpg',
        'assets/images/phong01_03.jpg',
      ],
      'bookings': 150,
      'amenities': ['Wi-Fi Miễn Phí', 'Hướng Núi', 'Bữa Sáng', 'Không Hút Thuốc', 'Trung Tâm Thể Dục', 'Giường Cỡ Queen'],
      'adults': 2,
    },
    {
      'id': 'P004',
      'name': 'Phòng Suite',
      'price': 4000000,
      'rating': 4.8,
      'image': 'assets/images/phong02_01.jpg',
       'images': [
        'assets/images/phong02_01.jpg',
        'assets/images/phong02_02.jpg',
        'assets/images/phong02_03.jpg',
      ],
      'bookings': 80,
      'amenities': ['Máy lạnh', 'Tủ lạnh', 'TV', 'Bồn tắm'],
      'adults': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phòng đã lưu', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF0077FF),
      ),
      body: _savedRooms.isEmpty
          ? const Center(
              child: Text(
                'Chưa có phòng nào được lưu.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _savedRooms.length,
              itemBuilder: (context, index) {
                return RoomCard(room: _savedRooms[index]);
              },
            ),
    );
  }
}
