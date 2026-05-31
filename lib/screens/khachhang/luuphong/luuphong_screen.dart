import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';

import 'package:hotel_booking_app/models/BaseModel/FavouriteModel.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';

import 'package:hotel_booking_app/controllers/khachhang/favourite/favourite_controller.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';

import 'package:hotel_booking_app/core/widgets/roomType/roomTypeCard.dart';
import '../trangchu/chitietphong_screen.dart';

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

  void _openRoomDetail(RoomTypeModel room) {
    final amenitiesForRoom = _amenities
        .where((amenity) => room.amensIds.contains(amenity.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            ChiTietPhongScreen(roomType: room, amenities: amenitiesForRoom),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PHÒNG ĐÃ LƯU',
        centerTitle: true,
        showBackButton: false,
      ),

      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _savedRooms.isEmpty
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
                  return RoomTypeCard(
                    roomType: room,
                    amensList: _amenities,
                    onTap: () => _openRoomDetail(room),
                  );
                },
              ),
      ),
    );
  }
}
