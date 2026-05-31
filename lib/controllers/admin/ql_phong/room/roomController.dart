import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/services/room_service/room_service.dart';

class RoomController extends ChangeNotifier {
  final PhongService _service = PhongService();

  List<RoomModel> rooms = [];
  List<RoomModel> filteredRooms = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadRooms() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      rooms = await _service.getAllRooms();

      rooms = rooms.where((room) => room.isDeleted == false).toList();

      rooms.sort((a, b) {
        final floorCompare = a.floor.compareTo(b.floor);
        if (floorCompare != 0) return floorCompare;
        return a.roomNumber.compareTo(b.roomNumber);
      });

      filteredRooms = List.from(rooms);
    } catch (e) {
      errorMessage = 'Lỗi tải danh sách phòng: $e';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String keyword) {
    final text = keyword.trim().toLowerCase();

    if (text.isEmpty) {
      filteredRooms = List.from(rooms);
    } else {
      filteredRooms = rooms.where((room) {
        return room.roomNumber.toLowerCase().contains(text) ||
            room.floor.toString().contains(text) ||
            room.status.name.toLowerCase().contains(text) ||
            room.roomTypeId.toLowerCase().contains(text);
      }).toList();
    }

    notifyListeners();
  }

  Future<bool> addRoom(RoomModel room) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.addRoom(room);
      await loadRooms();

      return true;
    } catch (e) {
      errorMessage = 'Lỗi thêm phòng: $e';
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRoom(String id, Map<String, dynamic> data) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.updateRoom(id, data);
      await loadRooms();

      return true;
    } catch (e) {
      errorMessage = 'Lỗi cập nhật phòng: $e';
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRoomStatus(String id, RoomStatus status) async {
    return updateRoom(id, {'status': status.name});
  }

  Future<bool> lockTemporary(String id) async {
    return updateRoomStatus(id, RoomStatus.maintenance);
  }

  Future<bool> lockPermanent(String id) async {
    return updateRoomStatus(id, RoomStatus.locked);
  }

  Future<bool> unlockRoom(String id) async {
    return updateRoomStatus(id, RoomStatus.available);
  }

  Future<bool> softDeleteRoom(String id) async {
    return updateRoom(id, {
      'isDeleted': true,
      'status': RoomStatus.locked.name,
    });
  }
}
