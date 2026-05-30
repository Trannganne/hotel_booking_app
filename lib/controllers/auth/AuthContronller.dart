import 'package:flutter/foundation.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authcontronller extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _userModel;
  bool _isLoading = false;
  String? _role;
  String? _errorMessage;

  UserModel? get userModel => _userModel;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  String? get role => _role;

  User? get currentUser => _authService.currentUser;

  String? get uid => _authService.uid;

  String get userId {
    if (_authService.uid == null) {
      throw Exception("Chưa đăng nhập");
    }

    return _authService.uid!;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // =========================
  // ĐĂNG KÝ USER
  // =========================
  Future<void> dangKyUser({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    String? avatar,
  }) async {
    _setLoading(true);

    try {
      final result = await _authService.dangKy(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw Exception("Không tạo được tài khoản");
      }

      await _authService.luuThongTinUser(
        uid: user.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        avatar: avatar,
        role: "CUSTOMER",
      );

      await _authService.guiEmailXacMinh();

      final data = await _authService.layThongTinUser(user.uid);

      if (data != null) {
        _userModel = UserModel.fromJson(
          data,
          user.uid,
        );
      }

      _role = "CUSTOMER";

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // ĐĂNG NHẬP USER
  // =========================
  Future<String> dangNhapUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final userRole = await _authService.dangNhap(
        email: email,
        password: password,
      );

      final currentUid = _authService.uid;

      if (currentUid != null) {
        final data = await _authService.layThongTinUser(currentUid);

        if (data != null) {
          _userModel = UserModel.fromJson(data, currentUid);
        } else {
          _userModel = null;
        }
      }

      _role = userRole;

      notifyListeners();

      return userRole;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // GỬI EMAIL XÁC MINH
  // =========================
  Future<void> guiEmailXacMinh() async {
    _setLoading(true);

    try {
      await _authService.guiEmailXacMinh();
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // KIỂM TRA EMAIL XÁC MINH
  // =========================
  Future<bool> kiemTraEmailDaXacMinh() async {
    _setLoading(true);

    try {
      return await _authService.kiemTraEmailDaXacMinh();
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // LOAD USER HIỆN TẠI
  // =========================
  Future<void> loadCurrentUser() async {
    final currentUid = _authService.uid;

    if (currentUid == null) {
      _userModel = null;
      _role = null;
      notifyListeners();
      return;
    }

    final data = await _authService.layThongTinUser(currentUid);

    if (data != null) {
      _userModel = UserModel.fromJson(data, currentUid);
      _role = _userModel?.role ?? "CUSTOMER";
    } else {
      _userModel = null;
      _role = null;
    }

    notifyListeners();
  }

  // =========================
  // CẬP NHẬT PROFILE
  // =========================
  Future<void> capNhatProfile({
    required String fullName,
    required String phoneNumber,
    String? avatar,
  }) async {
    final currentUid = _authService.uid;

    if (currentUid == null) {
      throw Exception("Bạn chưa đăng nhập");
    }

    _setLoading(true);

    try {
      await _authService.capNhatThongTinUser(
        uid: currentUid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatar: avatar,
      );

      final data = await _authService.layThongTinUser(currentUid);

      if (data != null) {
        _userModel = UserModel.fromJson(data, currentUid);
      }

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // ĐỔI MẬT KHẨU
  // =========================
  Future<void> doiMatKhau({
    required String newPassword,
  }) async {
    _setLoading(true);

    try {
      await _authService.doiMatKhau(
        newPassword: newPassword,
      );
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // QUÊN MẬT KHẨU
  // =========================
  Future<void> quenMatKhau({
    required String email,
  }) async {
    _setLoading(true);

    try {
      await _authService.quenMatKhau(
        email: email,
      );
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // ĐĂNG XUẤT
  // =========================
  Future<void> dangXuat() async {
    await _authService.dangXuat();

    _userModel = null;
    _role = null;

    notifyListeners();
  }

  String layThongBaoLoiFirebase(FirebaseAuthException e) {
    return _authService.layThongBaoLoiFirebase(e);
  }
}

typedef AuthController = Authcontronller;