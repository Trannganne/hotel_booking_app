// services/danhgia_service/danhgia_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import '../../services/firebase_service/firestore_service.dart';
import '../../models/BaseModel/ReviewModel.dart';

class DanhGiaService {
  final db = FirestoreService();
  final _auth = AuthService();

  CollectionReference<ReviewModel> get _ref => db.colWithConverter<ReviewModel>(
    name: 'reviews',
    fromFirestore: (snap, _) => ReviewModel.fromJson(snap.data()!, snap.id),
    toFirestore: (dg, _) => dg.toJson(),
  );

  Future<void> addDanhGia(ReviewModel danhGia) async {
    final uid = _auth.uid;

    danhGia.userId = uid!;
    await _ref.add(danhGia);
  }

  Future<List<ReviewModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }
}
