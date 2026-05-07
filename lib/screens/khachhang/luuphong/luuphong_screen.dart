import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/FavouriteModel.dart';
import 'package:hotel_booking_app/screens/khachhang/trangchu/trangchu_screen.dart';

class LuuPhongScreen extends StatefulWidget {
  const LuuPhongScreen({super.key});

  @override
  State<LuuPhongScreen> createState() => _LuuPhongScreenState();
}

class _LuuPhongScreenState extends State<LuuPhongScreen> {
  final List<FavoriteModel> _savedRooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phòng đã lưu',
          style: TextStyle(color: Colors.white),
        ),
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
                return null; //RoomCard(room: _savedRooms.);
              },
            ),
    );
  }
}
