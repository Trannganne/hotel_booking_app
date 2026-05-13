import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/HotelModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class Hotelservice {
  final db = FirestoreService();

  // Collection đã gắn converter ( hàm này bắt buộc phải có trong mỗi service)
  CollectionReference<HotelModel> get _ref => db.colWithConverter<HotelModel>(
    name: 'hotel',
    fromFirestore: (snap, _) => HotelModel.fromJson(snap.data()!, snap.id),
    toFirestore: (r, _) => r.toJson(),
  );

  //============================ GET ============================
  // Hàm lấy thông tin hotel
  Future<HotelModel?> getHotel() async {
    final snapshot = await _ref.limit(1).get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.data();
  }
}
