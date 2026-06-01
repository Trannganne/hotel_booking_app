import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class Policyservice {
  final db = FirestoreService();

  CollectionReference<PolicyModel> get _ref => db.colWithConverter<PolicyModel>(
    name: 'policies',
    fromFirestore: (snap, _) => PolicyModel.fromJson(snap.data()!, snap.id),
    toFirestore: (policy, _) => policy.toJson(),
  );

  Future<List<PolicyModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<PolicyModel?> getByID(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }

  Future<String> addPolicy(PolicyModel policy) async {
    final docRef = await _ref.add(policy);
    return docRef.id;
  }

  Future<void> updatePolicy(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  Future<void> deletePolicy(String id) async {
    await _ref.doc(id).delete();
  }
}
