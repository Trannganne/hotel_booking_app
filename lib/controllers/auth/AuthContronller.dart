import 'package:flutter/foundation.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authcontronller extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String get_userId() {
    return _authService.uid!;
  }

  User? get currentUser => _authService.currentUser;

  String? get uid => _authService.uid;

  Future<UserModel?> getCurrentUserProfile() async {
    return await _authService.getCurrentUserProfile();
  }

  Future<User?> testLogin() async {
    return await _authService.testLogin();
  }

  Future<User?> login(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
