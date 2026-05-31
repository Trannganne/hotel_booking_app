import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';

import '../../../services/auth_service/auth_service.dart';
import '../auth/dangnhap_screen.dart';
import '../auth/doimk_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _hoTenController = TextEditingController();

  final TextEditingController _sdtController = TextEditingController();

  bool _dangTai = true;

  bool _dangCapNhat = false;

  String _email = '';

  String _avatar = '';

  @override
  void initState() {
    super.initState();

    _loadThongTin();
  }

  @override
  void dispose() {
    _hoTenController.dispose();

    _sdtController.dispose();

    super.dispose();
  }

  // =========================
  // LOAD USER INFO
  // =========================
  Future<void> _loadThongTin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final data = await _authService.layThongTinUser(user.uid);

      if (data != null) {
        _hoTenController.text = data['fullName']?.toString() ?? '';

        _sdtController.text = data['phoneNumber']?.toString() ?? '';

        _email = data['email']?.toString() ?? '';

        _avatar = data['avatar']?.toString() ?? '';
      }

      if (!mounted) return;

      setState(() {
        _dangTai = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangTai = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
    }
  }

  // =========================
  // UPDATE USER INFO
  // =========================
  Future<void> _capNhatThongTin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      _dangCapNhat = true;
    });

    try {
      await _authService.capNhatThongTinUser(
        uid: user.uid,

        data: {
          'fullName': _hoTenController.text.trim(),

          'phoneNumber': _sdtController.text.trim(),
        },
      );

      if (!mounted) return;

      setState(() {
        _dangCapNhat = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công')));
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangCapNhat = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi cập nhật: $e')));
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> _dangXuat() async {
    await _authService.dangXuat();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (_) => const DangNhapScreen()),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),

      appBar: CustomAppBar(
        title: "TÀI KHOẢN",
        centerTitle: true,
        showBackButton: false,
      ),

      body: _dangTai
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  // =========================
                  // AVATAR
                  // =========================
                  CircleAvatar(
                    radius: 55,

                    backgroundImage: _avatar.isNotEmpty
                        ? NetworkImage(_avatar)
                        : null,

                    child: _avatar.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // NAME
                  // =========================
                  Text(
                    _hoTenController.text,

                    style: const TextStyle(
                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // =========================
                  // EMAIL
                  // =========================
                  Text(
                    _email,

                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),

                  const SizedBox(height: 32),

                  // =========================
                  // FULL NAME
                  // =========================
                  TextField(
                    controller: _hoTenController,

                    decoration: InputDecoration(
                      labelText: 'Họ tên',

                      prefixIcon: const Icon(Icons.person_outline),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // PHONE
                  // =========================
                  TextField(
                    controller: _sdtController,

                    keyboardType: TextInputType.phone,

                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',

                      prefixIcon: const Icon(Icons.phone_outlined),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // UPDATE BUTTON
                  // =========================
                  SizedBox(
                    width: double.infinity,

                    height: 54,

                    child: ElevatedButton(
                      onPressed: _dangCapNhat ? null : _capNhatThongTin,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      child: _dangCapNhat
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,

                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Cập nhật thông tin',

                              style: TextStyle(
                                fontSize: 16,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // CHANGE PASSWORD
                  // =========================
                  SizedBox(
                    width: double.infinity,

                    height: 54,

                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const DoiMatKhauScreen(),
                          ),
                        );
                      },

                      icon: const Icon(Icons.lock_reset),

                      label: const Text(
                        'Đổi mật khẩu',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // LOGOUT
                  // =========================
                  SizedBox(
                    width: double.infinity,

                    height: 54,

                    child: OutlinedButton.icon(
                      onPressed: _dangXuat,

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),

                      icon: const Icon(Icons.logout),

                      label: const Text(
                        'Đăng xuất',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
