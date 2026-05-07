import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class AmenityService {
  final _db = FirestoreService();

  // Collection đã gắn converter
  CollectionReference<Amenitymodel> get _ref =>
      _db.colWithConverter<Amenitymodel>(
        name: 'amenities',
        fromFirestore: (snap, _) =>
            Amenitymodel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  Future<List<Amenitymodel>> getAllUtils() async {
    final snapshot = await _ref.get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<List<Amenitymodel>> getAmenitiesByIds(List<String> ids) async {
    try {
      final futures = ids.map((id) => _ref.doc(id).get()).toList();
      final docs = await Future.wait(futures);

      return docs.where((doc) => doc.exists).map((doc) => doc.data()!).toList();
    } catch (e) {
      debugPrint("Lỗi lấy danh sách tiện ích cho trang chủ: $e");
      return [];
    }
  }
}
