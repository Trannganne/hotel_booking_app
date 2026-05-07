// services/firebase_service/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Lấy collection dạng Map ( dùng nhanh, không có type-safe)
  //CollectionReference col(String name) => db.collection(name);

  // Lấy collection có converter (dùng với Model)
  // Tự động convert giữa Map <-> Object
  CollectionReference<T> colWithConverter<T>({
    required String name,
    required T Function(
      DocumentSnapshot<Map<String, dynamic>>,
      SnapshotOptions?,
    )
    fromFirestore,
    required Map<String, dynamic> Function(T, SetOptions?) toFirestore,
  }) {
    return db
        .collection(name)
        .withConverter<T>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
  }
}
