import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/FavouriteModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';

class FavouriteService {
  final db = FirestoreService();
  final AuthService _auth = AuthService();

  // Collection đã gắn converter
  CollectionReference<FavouriteModel> get _ref =>
      db.colWithConverter<FavouriteModel>(
        name: 'favourite',
        fromFirestore: (snap, _) =>
            FavouriteModel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  Future<List<FavouriteModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).where((favourite) => favourite.userId == _auth.uid).toList();
  }

  Future<void> addFavourite(FavouriteModel favourite) async {
    final uid = _auth.uid;
    favourite.userId = uid!;
    await _ref.add(favourite);
  }

  Future<void> removeFavourite(String id) async {
    await _ref.doc(id).delete();
  }
}
