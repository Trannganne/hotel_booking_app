import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../admin/admin_home_screen.dart';
import 'dangky_screen.dart';
import 'resetpass_screen.dart';
import 'setup_profile_screen.dart';
import 'taikhoankh_screen.dart';
import 'verify_email_screen.dart';

class DangNhapScreen extends StatefulWidget {
  const DangNhapScreen({super.key});

  @override
  State<DangNhapScreen> createState() => _DangNhapScreenState();
}

class _DangNhapScreenState extends State<DangNhapScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _dangXuLy = false;
  bool _anMatKhau = true;

  @override
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  Future<void> _dangNhap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _dangXuLy = true;
    });

    try {
      final credential = await _authService.dangNhap(
        email: _emailController.text.trim(),
        matKhau: _matKhauController.text.trim(),
      );

      final user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Không tìm thấy tài khoản',
        );
      }

      await user.reload();

      final freshUser = _authService.currentUser ?? user;

      if (!mounted) return;

      // Nếu là admin cố định thì vào trang admin luôn
      if (_authService.laAdminEmail(freshUser.email)) {
        await _authService.taoThongTinAdminNeuChuaCo(
          uid: freshUser.uid,
          email: freshUser.email ?? '',
        );

        if (!mounted) return;

        setState(() {
          _dangXuLy = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminHomeScreen(),
          ),
        );
        return;
      }

      // User thường phải xác minh email
      if (!freshUser.emailVerified) {
        setState(() {
          _dangXuLy = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(
              uid: freshUser.uid,
              email: freshUser.email ?? '',
            ),
          ),
        );
        return;
      }

      final userData = await _authService.layThongTinUser(freshUser.uid);

      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      // Nếu user chưa setup profile thì vào setup
      if (userData == null || userData['profileCompleted'] != true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SetupProfileScreen(
              uid: freshUser.uid,
              email: freshUser.email ?? '',
            ),
          ),
        );
        return;
      }

      final vaiTro = userData['vaiTro']?.toString().toUpperCase();

      if (vaiTro == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminHomeScreen(),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TaiKhoanKhScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authService.layThongBaoLoiFirebase(e)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi đăng nhập: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.hotel,
                      size: 85,
                      color: primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Chào mừng bạn quay lại',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Nhập email của bạn',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập email';
                        }

                        final email = value.trim();

                        if (!email.contains('@') || !email.contains('.')) {
                          return 'Email không hợp lệ';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _matKhauController,
                      obscureText: _anMatKhau,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!_dangXuLy) {
                          _dangNhap();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        hintText: 'Nhập mật khẩu',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _anMatKhau
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _anMatKhau = !_anMatKhau;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }

                        if (value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _dangXuLy
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResetPassScreen(),
                                  ),
                                );
                              },
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _dangXuLy ? null : _dangNhap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _dangXuLy
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản?'),
                        TextButton(
                          onPressed: _dangXuLy
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DangKyScreen(),
                                    ),
                                  );
                                },
                          child: const Text('Đăng ký'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}