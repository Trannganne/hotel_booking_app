import 'package:flutter/foundation.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authcontronller extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get_userId() {
    return _authService.uid!;
  }

  User? get currentUser => _authService.currentUser;

  String? get uid => _authService.uid;

  Future<void> logout() async {
    await _authService.signOut();
  }

  /// HÀM ĐĂNG NHẬP: Xử lý luồng đăng nhập toàn cục
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Thông báo cho UI hiển thị vòng tròn tải trang (Loading)

    try {
      // Bước A: Gọi AuthService thực hiện đăng nhập tài khoản (Firebase Auth)
      final userAuth = await _authService.signIn(email, password);

      if (userAuth != null) {
        // Bước B: Nếu đăng nhập thành công, lập tức bốc dữ liệu UserModel từ Firestore về
        _userModel = await _authService.getCurrentUserModel();

        if (_userModel != null) {
          _isLoading = false;
          notifyListeners(); // Cập nhật lại giao diện khi có đầy đủ dữ liệu người dùng
          return true; // Đăng nhập và lấy thông tin thành công
        } else {
          _errorMessage = "Không tìm thấy dữ liệu tài khoản trên hệ thống!";
        }
      } else {
        _errorMessage = "Email hoặc mật khẩu không chính xác!";
      }
    } catch (e) {
      _errorMessage = "Đã xảy ra lỗi hệ thống: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false; // Đăng nhập thất bại
  }

  Future<void> fetchCurrentUserProfile() async {
    if (_authService.uid == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _userModel = await _authService.getCurrentUserModel();
    } catch (e) {
      print("Lỗi khi tải thông tin Profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
