import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth/AuthContronller.dart';
import 'dangnhap_screen.dart';

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
  bool _dangKiemTra = false;
  bool _dangGuiLai = false;

  Future<void> _kiemTraEmail() async {
    setState(() {
      _dangKiemTra = true;
    });

    try {
      final daXacMinh =
          await context.read<Authcontronller>().kiemTraEmailDaXacMinh();

      if (!mounted) return;

      setState(() {
        _dangKiemTra = false;
      });

      if (!daXacMinh) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email chưa được xác minh. Vui lòng kiểm tra Gmail',
            ),
          ),
        );
        return;
      }

      await context.read<Authcontronller>().dangXuat();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Xác minh email thành công. Vui lòng đăng nhập lại',
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DangNhapScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangKiemTra = false;
      });

      final authController = context.read<Authcontronller>();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authController.layThongBaoLoiFirebase(e),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangKiemTra = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi: $e',
          ),
        ),
      );
    }
  }

  Future<void> _guiLaiEmail() async {
    setState(() {
      _dangGuiLai = true;
    });

    try {
      await context.read<Authcontronller>().guiEmailXacMinh();

      if (!mounted) return;

      setState(() {
        _dangGuiLai = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Đã gửi lại email xác minh',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangGuiLai = false;
      });

      final authController = context.read<Authcontronller>();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authController.layThongBaoLoiFirebase(e),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangGuiLai = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi: $e',
          ),
        ),
      );
    }
  }

  Future<void> _dangXuat() async {
    await context.read<Authcontronller>().dangXuat();

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
    const Color primary = Color(0xFF2388E8);

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
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
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
                    'Hệ thống đã gửi link xác minh đến:\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Sau khi bấm vào link trong Gmail, quay lại đây và bấm nút bên dưới.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
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
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
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