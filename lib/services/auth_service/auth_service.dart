import 'package:firebase_auth/firebase_auth.dart';

// Duy Hưng cứ tự nhiên thêm/sửa các hàm cần thiết vào nha.
// Tui chỉ viết trước vài hàm để mấy bạn kia lấy uid thoiiii

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
