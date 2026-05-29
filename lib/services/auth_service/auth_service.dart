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
      print("AUTH DEBUG: bat dau dang nhap $email");

      final result = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception("Firebase Auth timeout sau 15 giay");
            },
          );

      print("AUTH DEBUG: dang nhap Firebase Auth thanh cong");

      final uid = result.user!.uid;
      print("AUTH DEBUG: uid = $uid");

      final doc = await _userRef
          .doc(uid)
          .get()
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception("Firestore users timeout sau 15 giay");
            },
          );

      print("AUTH DEBUG: doc users exists = ${doc.exists}");

      if (!doc.exists || doc.data() == null) {
        print("AUTH DEBUG: khong tim thay document users/$uid");
        return null;
      }

      print("AUTH DEBUG: lay UserModel thanh cong");
      return doc.data();
    } on FirebaseAuthException catch (e) {
      print("AUTH DEBUG: loi FirebaseAuth: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("AUTH DEBUG: loi khac: $e");
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
