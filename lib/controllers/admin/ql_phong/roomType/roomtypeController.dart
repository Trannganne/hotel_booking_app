import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/services/cloudinary_service/cloudinary_service.dart';
import 'package:hotel_booking_app/services/roomType_service/roomType_Service.dart';

class RoomTypeController extends ChangeNotifier {
  final RoomTypeService _service = RoomTypeService();
  final CloudinaryService _cloudinary = CloudinaryService();

  final url_default =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHUV4i5JNuLHnELyqGoCNRdVcjtIOnoQMI8Q&s";

  List<RoomTypeModel> rooms = [];
  bool isLoading = false;

  // Thêm room type
  Future<void> addRoomType(RoomTypeModel room, List<File> images) async {
    try {
      isLoading = true;
      notifyListeners();

      final imageUrls = await _cloudinary.uploadMultipleImages(images);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading = true;
      notifyListeners();
    });

    try {
      rooms = await _service.getAll();

      debugPrint("ROOM TYPE COUNT: ${rooms.length}");
      for (final room in rooms) {
        debugPrint("ROOM TYPE: id=${room.id}, name=${room.roomTypeName}");
      }
    } catch (e) {
      debugPrint("Lỗi load room_types: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  // Lấy loại phòng theo id trong booking
  Future<RoomTypeModel?> getRoomTypeById(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      return await _service.getByID(id);
    } catch (e) {
      debugPrint("Lỗi khi lấy loại phòng theo id booking: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Search
  Future<void> search(String keyword) async {
    isLoading = true;
    notifyListeners();

    try {
      rooms = await _service.searchByName(keyword);
    } catch (e) {
      debugPrint("Lỗi search room_types: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRoomType(RoomTypeModel room, List<File> newImages) async {
    if (room.id == null || room.id!.isEmpty) {
      debugPrint("Lỗi update roomtype: id rỗng");
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final oldImages = List<String>.from(room.imagesList);

      if (newImages.isNotEmpty) {
        final uploadedUrls = await _cloudinary.uploadMultipleImages(newImages);
        room.imagesList = [...oldImages, ...uploadedUrls];
      }

      if (room.imagesList.isEmpty) {
        room.imagesList = [url_default];
      }

      await _service.updateRoomType(room.id!, room);
      await loadRooms();

      return true;
    } catch (e) {
      debugPrint("Lỗi cập nhật roomtype: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRoomType(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.deleteRoomType(id);
      await loadRooms();

      return true;
    } catch (e) {
      debugPrint("Lỗi xóa roomtype: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
