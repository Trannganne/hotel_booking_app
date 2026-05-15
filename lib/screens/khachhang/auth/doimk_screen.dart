import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/auth_service/auth_service.dart';

class DoiMkScreen extends StatefulWidget {
  const DoiMkScreen({super.key});

  @override
  State<DoiMkScreen> createState() => _DoiMkScreenState();
}

class _DoiMkScreenState extends State<DoiMkScreen> {
  final _formKey = GlobalKey<FormState>();

  final _matKhauHienTaiController = TextEditingController();
  final _matKhauMoiController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();

  final _authService = AuthService();

  bool _dangXuLy = false;
  bool _anMatKhauCu = true;
  bool _anMatKhauMoi = true;
  bool _anXacNhan = true;

  @override
  void dispose() {
    _matKhauHienTaiController.dispose();
    _matKhauMoiController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  Future<void> _doiMatKhau() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _dangXuLy = true;
    });

    try {
      await _authService.doiMatKhau(
        matKhauHienTai: _matKhauHienTaiController.text,
        matKhauMoi: _matKhauMoiController.text,
      );

      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công')),
      );

      Navigator.pop(context);
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
        SnackBar(content: Text('Lỗi đổi mật khẩu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
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
                      Icons.password,
                      size: 85,
                      color: primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cập nhật mật khẩu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _matKhauHienTaiController,
                      obscureText: _anMatKhauCu,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu hiện tại',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _anMatKhauCu
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _anMatKhauCu = !_anMatKhauCu;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu hiện tại';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _matKhauMoiController,
                      obscureText: _anMatKhauMoi,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
                        prefixIcon: const Icon(Icons.lock_reset),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _anMatKhauMoi
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _anMatKhauMoi = !_anMatKhauMoi;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }

                        if (value.length < 6) {
                          return 'Mật khẩu mới phải có ít nhất 6 ký tự';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _xacNhanMatKhauController,
                      obscureText: _anXacNhan,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu mới',
                        prefixIcon: const Icon(Icons.verified_user_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _anXacNhan
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _anXacNhan = !_anXacNhan;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận mật khẩu mới';
                        }

                        if (value != _matKhauMoiController.text) {
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
                        onPressed: _dangXuLy ? null : _doiMatKhau,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _dangXuLy
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Đổi mật khẩu'),
                      ),
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