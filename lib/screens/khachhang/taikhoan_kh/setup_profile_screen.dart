import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/auth_service/auth_service.dart';
import 'taikhoankh_screen.dart';

class SetupProfileScreen extends StatefulWidget {
  final String uid;
  final String email;

  const SetupProfileScreen({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _hoTenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _ngaySinhController = TextEditingController();
  final _quocGiaController = TextEditingController(text: 'Việt Nam');
  final _tinhThanhController = TextEditingController();
  final _zipCodeController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _dangLuu = false;

  @override
  void dispose() {
    _hoTenController.dispose();
    _sdtController.dispose();
    _ngaySinhController.dispose();
    _quocGiaController.dispose();
    _tinhThanhController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _chonNgaySinh() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (pickedDate == null) return;

    _ngaySinhController.text =
        '${pickedDate.day.toString().padLeft(2, '0')}/'
        '${pickedDate.month.toString().padLeft(2, '0')}/'
        '${pickedDate.year}';
  }

  Future<void> _luuHoSo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _dangLuu = true;
    });

    try {
      await _authService.luuThongTinKhachHang(
        uid: widget.uid,
        email: widget.email,
        hoTen: _hoTenController.text,
        soDienThoai: _sdtController.text,
        ngaySinh: _ngaySinhController.text,
        quocGia: _quocGiaController.text,
        tinhThanh: _tinhThanhController.text,
        zipCode: _zipCodeController.text,
      );

      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TaiKhoanKhScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authService.layThongBaoLoiFirebase(e)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi lưu hồ sơ: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Thiết lập hồ sơ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 85,
                      color: primary,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Hoàn tất thông tin cá nhân',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Vui lòng nhập đầy đủ thông tin để tiếp tục',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      initialValue: widget.email,
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
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Họ tên',
                        hintText: 'Nhập họ tên của bạn',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }

                        if (value.trim().length < 2) {
                          return 'Họ tên quá ngắn';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _sdtController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        hintText: 'Ví dụ: 0912345678',
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
                        hintText: 'Chọn ngày sinh',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng chọn ngày sinh';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _quocGiaController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Quốc gia',
                        prefixIcon: Icon(Icons.public),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập quốc gia';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _tinhThanhController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Tỉnh / Thành phố',
                        hintText: 'Ví dụ: TP. Hồ Chí Minh, Hà Nội...',
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tỉnh / thành phố';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Zip code',
                        hintText: 'Ví dụ: 700000',
                        prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập zip code';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _dangLuu ? null : _luuHoSo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _dangLuu
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Lưu hồ sơ',
                                style: TextStyle(fontSize: 16),
                              ),
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