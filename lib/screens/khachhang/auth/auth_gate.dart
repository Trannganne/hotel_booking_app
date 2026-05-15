import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/auth_service/auth_service.dart';
import '../../admin/admin_home_screen.dart';
import '../taikhoan_kh/setup_profile_screen.dart';
import '../taikhoan_kh/taikhoankh_screen.dart';
import 'dangnhap_screen.dart';
import 'verify_email_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> _kiemTraManHinhTiepTheo(User user) async {
    final authService = AuthService();

    await user.reload();

    final freshUser = authService.currentUser;

    if (freshUser == null) {
      return const DangNhapScreen();
    }

    if (authService.laAdminEmail(freshUser.email)) {
      await authService.taoThongTinAdminNeuChuaCo(
        uid: freshUser.uid,
        email: freshUser.email ?? '',
      );

      return const AdminHomeScreen();
    }

    if (!freshUser.emailVerified) {
      return VerifyEmailScreen(
        uid: freshUser.uid,
        email: freshUser.email ?? '',
      );
    }

    final userData = await authService.layThongTinUser(freshUser.uid);

    if (userData == null || userData['profileCompleted'] != true) {
      return SetupProfileScreen(
        uid: freshUser.uid,
        email: freshUser.email ?? '',
      );
    }

    final vaiTro = userData['vaiTro']?.toString().toUpperCase();

    if (vaiTro == 'ADMIN') {
      return const AdminHomeScreen();
    }

    return const TaiKhoanKhScreen();
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const DangNhapScreen();
        }

        return FutureBuilder<Widget>(
          future: _kiemTraManHinhTiepTheo(user),
          builder: (context, screenSnapshot) {
            if (screenSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return screenSnapshot.data ?? const DangNhapScreen();
          },
        );
      },
    );
  }
}