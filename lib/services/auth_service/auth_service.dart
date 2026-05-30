import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Khởi tạo db giống hệt
  final db = FirestoreService();

  // 2. Tạo một Reference Collection có gắn converter cho 'users'
  CollectionReference<UserModel> get _userRef => db.colWithConverter<UserModel>(
    name: 'users',
    fromFirestore: (snap, _) => UserModel.fromJson(snap.data()!, snap.id),
    toFirestore: (r, _) => r.toJson(),
  );

  //==================================================================
  // Đăng ký
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String avt,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    final userModel = UserModel(
      id: user.uid,
      fullName: fullName,
      email: email,
      phoneNumber: phone,
      avatar: avt,
    );

    await _userRef.doc(user.uid).set(userModel);

    return userModel;
  }

  // Đăng nhập
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;

      final doc = await _userRef.doc(uid).get();

      return doc.data()!;
    } on FirebaseAuthException catch (e) {
      print("Lỗi đăng nhập: ${e.message}");
      return null;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Lấy uid
  String? get uid => _auth.currentUser?.uid;

  // Lấy thông tin chi tiết của user
  Future<UserModel?> getCurrentUserModel() async {
    try {
      String? currentUid = _auth.currentUser?.uid;
      if (currentUid == null) return null;

      // Tìm đến doc có ID trùng với uid của tài khoản đang đăng nhập
      final snapshot = await _userRef.doc(currentUid).get();

      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    } catch (e) {
      print("Lỗi khi lấy thông tin UserModel: $e");
      return null;
    }
  }
}
