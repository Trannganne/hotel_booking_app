import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import 'dangnhap_screen.dart';
import 'setup_profile_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String uid;
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _authService = AuthService();

  bool _dangKiemTra = false;
  bool _dangGuiLai = false;

  Future<void> _kiemTraEmail() async {
    setState(() {
      _dangKiemTra = true;
    });

    try {
      final daXacMinh = await _authService.kiemTraEmailDaXacMinh();

      if (!mounted) return;

      setState(() {
        _dangKiemTra = false;
      });

      if (!daXacMinh) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email chưa được xác minh'),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SetupProfileScreen(
            uid: widget.uid,
            email: widget.email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangKiemTra = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authService.layThongBaoLoiFirebase(e))),
      );
    }
  }

  Future<void> _guiLaiEmail() async {
    setState(() {
      _dangGuiLai = true;
    });

    try {
      await _authService.guiEmailXacMinh();

      if (!mounted) return;

      setState(() {
        _dangGuiLai = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi lại email xác minh'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangGuiLai = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authService.layThongBaoLoiFirebase(e))),
      );
    }
  }

  Future<void> _dangXuat() async {
    await _authService.dangXuat();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const DangNhapScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Xác minh email'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _dangXuat,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 90,
                    color: primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Kiểm tra email của bạn',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Firebase đã gửi link xác minh đến:\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _dangKiemTra ? null : _kiemTraEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _dangKiemTra
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Tôi đã xác minh email'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _dangGuiLai ? null : _guiLaiEmail,
                    child: Text(
                      _dangGuiLai
                          ? 'Đang gửi lại...'
                          : 'Gửi lại email xác minh',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}