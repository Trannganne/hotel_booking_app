import 'package:firebase_auth/firebase_auth.dart';

//Duy Hưng cứ tự nhiên thêm/ sửa các hàm cần thiết vào nha.
//Tui chỉ viết trước vài hàm để mấy bạn kia lấy uid thoiiii

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Dữ liệu giả lập - khi có chức năng đăng ký/ đăng nhập hoàn chỉnh sẽ xóa
  static const String mockId = "user_test_1";

  // Đăng ký

  // Đăng nhập
  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy id của tài khoản đang đăng nhập
  // Hiện tại đang dùng mockId
  String? get uid => _auth.currentUser?.uid ?? mockId;
}
