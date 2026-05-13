import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/HotelModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class HotelService {
  final db = FirestoreService();

  // Collection đã gắn converter
  CollectionReference<HotelModel> get _ref =>
      db.colWithConverter<HotelModel>(
        name: 'hotel',
        fromFirestore: (snap, _) =>
            HotelModel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  Future<List<HotelModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<HotelModel?> getByID(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }

}
