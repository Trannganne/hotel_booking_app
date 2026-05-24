import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/services/cloudinary_service/cloudinary_service.dart';
import 'package:hotel_booking_app/services/roomType_service/roomType_Service.dart';

class RoomTypeController extends ChangeNotifier {
  final RoomTypeService _service = RoomTypeService();
  final CloudinaryService _cloudinary = CloudinaryService();

  List<RoomTypeModel> rooms = [];
  bool isLoading = false;

  // Thêm room type
  Future<void> addRoomType(RoomTypeModel room, List<File> images) async {
    try {
      isLoading = true;
      notifyListeners();

      List<String> imageUrls = [];

      imageUrls = await _cloudinary.uploadMultipleImages(images);

      room.imagesList = imageUrls;
      await _service.addRoomType(room);
      await loadRooms();
    } catch (e) {
      debugPrint("Lỗi thêm roomtype: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load tất cả room type
  Future<void> loadRooms() async {
    isLoading = true;
    notifyListeners();

    try {
      rooms = await _service.getAll();
    } catch (e) {
      debugPrint("Lỗi load rooms: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Lấy loại phòng theo id trong booking
  Future<RoomTypeModel?> getRoomTypeById(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      return await _service.getByID(id);
    } catch (e) {
      debugPrint("Lỗi khi lấy loại phòng theo id booking: ");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Search
  Future<void> search(String keyword) async {
    isLoading = true;
    notifyListeners();

    rooms = await _service.searchByName(keyword);

    isLoading = false;
    notifyListeners();
  }
}
