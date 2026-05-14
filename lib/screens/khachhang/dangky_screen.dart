import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import 'dangnhap_screen.dart';
import 'verify_email_screen.dart';

class DangKyScreen extends StatefulWidget {
  const DangKyScreen({super.key});

  @override
  State<DangKyScreen> createState() => _DangKyScreenState();
}

class _DangKyScreenState extends State<DangKyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();

  final _authService = AuthService();

  bool _dangXuLy = false;
  bool _anMatKhau = true;
  bool _anXacNhanMatKhau = true;

  @override
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  Future<void> _dangKy() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    if (_authService.laAdminEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email này được dùng cho tài khoản Admin, không thể đăng ký'),
        ),
      );
      return;
    }

    setState(() {
      _dangXuLy = true;
    });

    try {
      final credential = await _authService.dangKy(
        email: email,
        matKhau: _matKhauController.text.trim(),
      );

      final user = credential.user;

      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tạo được tài khoản')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            uid: user.uid,
            email: user.email ?? email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authService.layThongBaoLoiFirebase(e))),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng ký: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.person_add_alt_1,
                      size: 80,
                      color: primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tạo tài khoản',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
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
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
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

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _xacNhanMatKhauController,
                      obscureText: _anXacNhanMatKhau,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        prefixIcon: const Icon(Icons.lock_reset),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _anXacNhanMatKhau
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _anXacNhanMatKhau = !_anXacNhanMatKhau;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận mật khẩu';
                        }

                        if (value != _matKhauController.text) {
                          return 'Mật khẩu xác nhận không khớp';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _dangXuLy ? null : _dangKy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _dangXuLy
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Đăng ký'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DangNhapScreen(),
                          ),
                        );
                      },
                      child: const Text('Đã có tài khoản? Đăng nhập'),
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