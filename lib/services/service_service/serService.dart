import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class Serservice {
  final db = FirestoreService();

  // Collection đã gắn converter
  CollectionReference<ServiceModel> get _ref =>
      db.colWithConverter<ServiceModel>(
        name: 'services',
        fromFirestore: (snap, _) =>
            ServiceModel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  // Get all services
  Future<List<ServiceModel>> getAllServices() async {
    try {
      final snapshot = await _ref.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting services: $e');
      return [];
    }
  }
}
