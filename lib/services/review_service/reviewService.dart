// services/review_service/reviewService.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import '../firebase_service/firestore_service.dart';
import '../../models/BaseModel/ReviewModel.dart';

class Reviewservice {
  final db = FirestoreService();
  final _auth = AuthService();

  CollectionReference<ReviewModel> get _ref => db.colWithConverter<ReviewModel>(
    name: 'reviews',
    fromFirestore: (snap, _) => ReviewModel.fromJson(snap.data()!, snap.id),
    toFirestore: (dg, _) => dg.toJson(),
  );

  Future<void> addReview(ReviewModel review) async {
    final uid = _auth.uid;

    review.userId = uid!;
    await _ref.add(review);
  }
}
