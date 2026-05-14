import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _authService = AuthService();

  bool _dangXuLy = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _guiEmailReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _dangXuLy = true;
    });

    try {
      await _authService.resetPassword(_emailController.text);

      if (!mounted) return;

      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi email đặt lại mật khẩu'),
        ),
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
        SnackBar(content: Text('Lỗi reset mật khẩu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 85,
                      color: primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Đặt lại mật khẩu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
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

                        if (!value.contains('@')) {
                          return 'Email không hợp lệ';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _dangXuLy ? null : _guiEmailReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _dangXuLy
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Gửi email đặt lại mật khẩu'),
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