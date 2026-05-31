import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class PhongService {
  final db = FirestoreService();

  CollectionReference<RoomModel> get _ref => db.colWithConverter<RoomModel>(
    name: 'rooms',
    fromFirestore: (snap, _) => RoomModel.fromJson(snap.data()!, snap.id),
    toFirestore: (room, _) => room.toJson(),
  );

  // Lấy danh sách tất cả phòng
  Future<List<RoomModel>> getAllRooms() async {
    final snapshot = await _ref.get();

    final rooms = snapshot.docs.map((doc) => doc.data()).toList();

    rooms.sort((a, b) {
      final floorCompare = a.floor.compareTo(b.floor);
      if (floorCompare != 0) return floorCompare;
      return a.roomNumber.compareTo(b.roomNumber);
    });

    return rooms;
  }

  // Lấy 1 phòng theo id
  Future<RoomModel?> getRoomById(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }

  // Thêm phòng mới
  Future<String> addRoom(RoomModel room) async {
    final docRef = _ref.doc();

    room.id = docRef.id;
    room.createdAt ??= DateTime.now();

    await docRef.set(room);
    return docRef.id;
  }

  // Cập nhật phòng
  Future<void> updateRoom(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  // Cập nhật trạng thái phòng
  Future<void> updateRoomStatus(String id, RoomStatus status) async {
    await _ref.doc(id).update({'status': status.name});
  }

  // Khóa tạm thời / bảo trì
  Future<void> lockTemporary(String id) async {
    await updateRoomStatus(id, RoomStatus.maintenance);
  }

  // Khóa vĩnh viễn
  Future<void> lockPermanent(String id) async {
    await updateRoomStatus(id, RoomStatus.locked);
  }

  // Mở khóa phòng
  Future<void> unlockRoom(String id) async {
    await updateRoomStatus(id, RoomStatus.available);
  }

  // Xóa mềm phòng
  Future<void> softDeleteRoom(String id) async {
    await _ref.doc(id).update({
      'isDeleted': true,
      'status': RoomStatus.locked.name,
    });
  }

  // ==========================================================
  // Các hàm cũ giữ lại tạm thời để tránh lỗi nếu màn cũ còn gọi
  // ==========================================================

  Future<List<Map<String, dynamic>>> getDanhSachPhong() async {
    final rooms = await getAllRooms();

    return rooms.map((room) {
      return {
        'id': room.id,
        'so_phong': room.roomNumber,
        'tang': room.floor,
        'loai': room.roomTypeId,
        'trang_thai': room.status.name,
        'isDeleted': room.isDeleted,
      };
    }).toList();
  }

  Future<bool> themPhong(Map<String, dynamic> phongMoi) async {
    try {
      final room = RoomModel(
        roomTypeId: phongMoi['roomTypeId'] ?? phongMoi['loai'] ?? '',
        roomNumber: phongMoi['roomNumber'] ?? phongMoi['so_phong'] ?? '',
        floor:
            int.tryParse(
              (phongMoi['floor'] ?? phongMoi['tang'] ?? 0).toString(),
            ) ??
            0,
        status: RoomStatus.available,
        isDeleted: false,
      );

      await addRoom(room);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> suaPhong(String id, Map<String, dynamic> thongTinMoi) async {
    try {
      await updateRoom(id, thongTinMoi);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> khoaPhong(String id, bool khoaVinhVien) async {
    try {
      if (khoaVinhVien) {
        await lockPermanent(id);
      } else {
        await lockTemporary(id);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
