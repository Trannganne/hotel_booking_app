import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

//============== VÍ DỤ LÀM VIỆC VỚI DỮ LIỆU ROOMTYPE VỚI FIREBASE =========================

class Policyservice {
  final db = FirestoreService();

  // Collection đã gắn converter
  CollectionReference<PolicyModel> get _ref => db.colWithConverter<PolicyModel>(
    name: 'policies',
    fromFirestore: (snap, _) => PolicyModel.fromJson(snap.data()!, snap.id),
    toFirestore: (r, _) => r.toJson(),
  );

  //============================ GET ============================
  // Hàm lấy danh sách tất cả chính sách
  Future<List<PolicyModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  // Hàm lấy 1 roomtype theo ID
  Future<PolicyModel?> getByID(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }
  //============================ CREATE ============================

  // Hàm thêm chính sách ( Firebase tự tạo ID( mã chính sách))
  Future<String> addPolicy(PolicyModel policy) async {
    await _ref.add(policy);
    return _ref.id;
  }

  //============================ UPDATE ============================
  // Hàm update thông tin chính sách
  Future<void> updatePolicy(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  //============================ QUERY ============================
}
