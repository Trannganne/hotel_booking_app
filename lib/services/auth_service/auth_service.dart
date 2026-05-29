import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dán UID admin thật vào đây
  static const String adminUid = "N15OlwNCRdZb6UsmEUtlriQOu1W2";

  User? get currentUser => _auth.currentUser;

  String? get uid => _auth.currentUser?.uid;

  Future<UserCredential> dangKy({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> luuThongTinUser({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? avatar,
    String role = "CUSTOMER",
  }) async {
    final user = UserModel(
      id: uid,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      avatar: avatar,
      role: role,
    );

    await _firestore.collection("users").doc(uid).set(
          user.toJson(),
        );
  }

  Future<Map<String, dynamic>?> layThongTinUser(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return doc.data();
  }

  Future<void> capNhatThongTinUser({
    required String uid,
    Map<String, dynamic>? data,
    String? fullName,
    String? phoneNumber,
    String? avatar,
  }) async {
    final Map<String, dynamic> updateData = {};

    if (data != null) {
      updateData.addAll(data);
    }

    if (fullName != null) {
      updateData["fullName"] = fullName;
    }

    if (phoneNumber != null) {
      updateData["phoneNumber"] = phoneNumber;
    }

    if (avatar != null) {
      updateData["avatar"] = avatar;
    }

    if (updateData.isEmpty) {
      return;
    }

    await _firestore.collection("users").doc(uid).update(updateData);
  }

  Future<void> guiEmailXacMinh() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Bạn chưa đăng nhập");
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> kiemTraEmailDaXacMinh() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Bạn chưa đăng nhập");
    }

    await user.reload();

    final currentUser = _auth.currentUser;

    return currentUser?.emailVerified ?? false;
  }

  Future<String> dangNhap({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user == null) {
      throw Exception("Không tìm thấy tài khoản");
    }

    await user.reload();

    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception("Không tìm thấy tài khoản");
    }

    // Admin không cần xác minh email
    if (currentUser.uid == adminUid) {
      return "ADMIN";
    }

    // User thường phải xác minh email
    if (!currentUser.emailVerified) {
      throw FirebaseAuthException(
        code: "email-not-verified",
        message: "Email chưa được xác minh",
      );
    }

    final doc = await _firestore.collection("users").doc(currentUser.uid).get();

    if (!doc.exists) {
      throw Exception("Không tìm thấy thông tin người dùng");
    }

    return "CUSTOMER";
  }

  Future<void> doiMatKhau({
    required String newPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Bạn chưa đăng nhập");
    }

    await user.updatePassword(newPassword);
  }

  Future<void> quenMatKhau({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> dangXuat() async {
    await _auth.signOut();
  }

  String layThongBaoLoiFirebase(FirebaseAuthException e) {
    switch (e.code) {
      case "email-already-in-use":
        return "Email này đã được sử dụng";

      case "invalid-email":
        return "Email không hợp lệ";

      case "weak-password":
        return "Mật khẩu quá yếu";

      case "user-not-found":
        return "Không tìm thấy tài khoản";

      case "wrong-password":
        return "Sai mật khẩu";

      case "invalid-credential":
        return "Email hoặc mật khẩu không đúng";

      case "email-not-verified":
        return "Email chưa được xác minh. Vui lòng kiểm tra Gmail và bấm vào link xác minh";

      case "requires-recent-login":
        return "Vui lòng đăng nhập lại để đổi mật khẩu";

      default:
        return "Lỗi: ${e.message}";
    }
  }
}