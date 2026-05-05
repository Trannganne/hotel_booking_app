import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

//============== VÍ DỤ LÀM VIỆC VỚI DỮ LIỆU ROOMTYPE VỚI FIREBASE =========================

class RoomTypeService {
  final db = FirestoreService();

  // Collection đã gắn converter ( hàm này bắt buộc phải có trong mỗi service)
  CollectionReference<RoomTypeModel> get _ref =>
      db.colWithConverter<RoomTypeModel>(
        name: 'room_types',
        fromFirestore: (snap, _) =>
            RoomTypeModel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  //============================ GET ============================
  // Hàm lấy danh sách tất cả loại phòng
  Future<List<RoomTypeModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  // Hàm lấy 1 roomtype theo ID
  Future<RoomTypeModel?> getByID(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }
  //============================ CREATE ============================

  // Hàm thêm loại phòng ( Firebase tự tạo ID( mã phòng))
  Future<void> addRoomType(RoomTypeModel roomType) async {
    await _ref.add(roomType);
  }

  //============================ UPDATE ============================
  // Hàm update thông tin loại phòng
  Future<void> updateRoom(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  //============================ QUERY ============================
  // SEARCH
  // TÌM THEO TÊN
  Future<List<RoomTypeModel>> searchByName(String keyword) async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((e) => e.data())
        .where(
          (r) => r.roomTypeName.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
  }

  // TÌM THEO GIÁ
  // TÌM THEO TIỆN ÍCH
}
