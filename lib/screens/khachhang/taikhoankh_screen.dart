import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import 'dangnhap_screen.dart';
import 'doimk_screen.dart';

class TaiKhoanKhScreen extends StatefulWidget {
  const TaiKhoanKhScreen({super.key});

  @override
  State<TaiKhoanKhScreen> createState() => _TaiKhoanKhScreenState();
}

class _TaiKhoanKhScreenState extends State<TaiKhoanKhScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _hoTenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _ngaySinhController = TextEditingController();
  final _quocGiaController = TextEditingController();
  final _tinhThanhController = TextEditingController();
  final _zipCodeController = TextEditingController();

  final _authService = AuthService();

  bool _dangTai = true;
  bool _dangLuu = false;

  @override
  void initState() {
    super.initState();
    _loadThongTin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _hoTenController.dispose();
    _sdtController.dispose();
    _ngaySinhController.dispose();
    _quocGiaController.dispose();
    _tinhThanhController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadThongTin() async {
    try {
      final user = _authService.currentUser;

      if (user == null) {
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DangNhapScreen()),
          (route) => false,
        );
        return;
      }

      final data = await _authService.layThongTinUser(user.uid);

      if (!mounted) return;

      _emailController.text = user.email ?? '';
      _hoTenController.text = data?['hoTen'] ?? '';
      _sdtController.text = data?['soDienThoai'] ?? '';
      _ngaySinhController.text = data?['ngaySinh'] ?? '';
      _quocGiaController.text = data?['quocGia'] ?? '';
      _tinhThanhController.text = data?['tinhThanh'] ?? '';
      _zipCodeController.text = data?['zipCode'] ?? '';

      setState(() {
        _dangTai = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangTai = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải thông tin: $e')),
      );
    }
  }

  Future<void> _chonNgaySinh() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (pickedDate == null) {
      return;
    }

    _ngaySinhController.text =
        '${pickedDate.day.toString().padLeft(2, '0')}/'
        '${pickedDate.month.toString().padLeft(2, '0')}/'
        '${pickedDate.year}';
  }

  Future<void> _capNhatThongTin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = _authService.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      _dangLuu = true;
    });

    try {
      await _authService.capNhatThongTinUser(
        uid: user.uid,
        data: {
          'hoTen': _hoTenController.text.trim(),
          'soDienThoai': _sdtController.text.trim(),
          'ngaySinh': _ngaySinhController.text.trim(),
          'quocGia': _quocGiaController.text.trim(),
          'tinhThanh': _tinhThanhController.text.trim(),
          'zipCode': _zipCodeController.text.trim(),
          'profileCompleted': true,
        },
      );

      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authService.layThongBaoLoiFirebase(e))),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật: $e')),
      );
    }
  }

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
    const primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Tài khoản khách hàng'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Đổi mật khẩu',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoiMkScreen()),
              );
            },
            icon: const Icon(Icons.lock_reset),
          ),
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: _dangXuat,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _dangTai
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFFEAF6FF),
                            child: Icon(
                              Icons.person_outline,
                              size: 45,
                              color: primary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _emailController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _hoTenController,
                            decoration: const InputDecoration(
                              labelText: 'Họ tên',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập họ tên';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _sdtController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Số điện thoại',
                              prefixIcon: Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }

                              if (!_authService.laSoDienThoaiHopLe(value)) {
                                return 'Số điện thoại không hợp lệ';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _ngaySinhController,
                            readOnly: true,
                            onTap: _chonNgaySinh,
                            decoration: const InputDecoration(
                              labelText: 'Ngày sinh',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _quocGiaController,
                            decoration: const InputDecoration(
                              labelText: 'Quốc gia',
                              prefixIcon: Icon(Icons.public),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _tinhThanhController,
                            decoration: const InputDecoration(
                              labelText: 'Tỉnh / Thành phố',
                              prefixIcon: Icon(Icons.location_city_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _zipCodeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Zip code',
                              prefixIcon:
                                  Icon(Icons.markunread_mailbox_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _dangLuu ? null : _capNhatThongTin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                              ),
                              child: _dangLuu
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Cập nhật thông tin'),
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