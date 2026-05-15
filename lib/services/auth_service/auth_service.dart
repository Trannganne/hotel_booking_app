import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

// Duy Hưng cứ tự nhiên thêm/sửa các hàm cần thiết vào nha.
// Tui chỉ viết trước vài hàm để mấy bạn kia lấy uid thoiiii

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  CollectionReference<UserModel> get _usersRef =>
      _firestoreService.colWithConverter<UserModel>(
        name: 'users',
        fromFirestore: (snap, _) => UserModel.fromJson(snap.data()!, snap.id),
        toFirestore: (user, _) => user.toJson(),
      );

  // Đăng nhập
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Lỗi đăng nhập: ${e.message}");
      return null;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Login test tạm thời
  Future<User?> testLogin() async {
    return await signIn("trngan0708@gmail.com", "123456");
  }

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Lấy uid
  String? get uid => _auth.currentUser?.uid;

  Future<UserModel?> getCurrentUserProfile() async {
    final userId = uid;
    if (userId == null || userId.isEmpty) return null;

    final doc = await _usersRef.doc(userId).get();
    return doc.data();
  }
}
