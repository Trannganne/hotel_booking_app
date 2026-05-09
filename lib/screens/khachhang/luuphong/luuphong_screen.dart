import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/BaseModel/FavouriteModel.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';

import 'package:hotel_booking_app/controllers/khachhang/favourite/favourite_controller.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';

import 'package:hotel_booking_app/core/widgets/roomType/roomTypeCard.dart';

class LuuPhongScreen extends StatefulWidget {
  const LuuPhongScreen({super.key});

  @override
  State<LuuPhongScreen> createState() => _LuuPhongScreenState();
}

class _LuuPhongScreenState extends State<LuuPhongScreen> {
  final FavouriteController _favouriteController = FavouriteController();
  final AmenityController _amenityController = AmenityController();
  final RoomTypeController _roomTypeController = RoomTypeController();

  List<FavouriteModel> _savedRooms = [];
  List<Amenitymodel> _amenities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _favouriteController.getAll();
      await _amenityController.loadAmenities();
      await _roomTypeController.loadRooms();
      setState(() {
        _savedRooms.clear();
        _savedRooms = List.from(_favouriteController.favourites);
        _amenities = List.from(_amenityController.amenities);
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi tải dữ liệu: $e');
    }
  }

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
                final favourite = _savedRooms[index];
                final room = _roomTypeController.rooms.firstWhere(
                  (r) => r.id == favourite.roomTypeId,
                  orElse: () => RoomTypeModel(
                    roomTypeName: 'Phòng không tìm thấy',
                    pricePerNight: 0,
                    area: 0,
                    bedType: '',
                    bedCount: 0,
                    maxOccupancy: 0,
                    view: '',
                    description: '',
                    policyId: '',
                  ),
                );
                return RoomTypeCard(room: room, amensList: _amenities);
              },
            ),
    );
  }
}
