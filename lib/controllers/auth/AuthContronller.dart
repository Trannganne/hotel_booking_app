import 'package:flutter/foundation.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authcontronller extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String get_userId() {
    return _authService.uid!;
  }

  User? get currentUser => _authService.currentUser;

  String? get uid => _authService.uid;
}
