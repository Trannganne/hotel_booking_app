import 'package:flutter/material.dart';
import 'dangnhap_screen.dart';

class SetupProfileScreen extends StatefulWidget {
  final String email;
  final String matKhau;
  final String soDienThoai;

  const SetupProfileScreen({
    Key? key,
    required this.email,
    required this.matKhau,
    required this.soDienThoai,
  }) : super(key: key);

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController _hoController = TextEditingController();
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _quocGiaController = TextEditingController(
    text: 'VietNam',
  );
  final TextEditingController _tinhController = TextEditingController(
    text: 'Ba Ria - Vung Tau',
  );
  final TextEditingController _thanhPhoController = TextEditingController(
    text: 'Vung Tau',
  );
  final TextEditingController _zipController = TextEditingController();

  bool _dangTaoTaiKhoan = false;

  @override
  void dispose() {
    _hoController.dispose();
    _tenController.dispose();
    _ngaySinhController.dispose();
    _quocGiaController.dispose();
    _tinhController.dispose();
    _thanhPhoController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _taoTaiKhoan() async {
    if (_hoController.text.trim().isEmpty ||
        _tenController.text.trim().isEmpty ||
        _ngaySinhController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin cá nhân')),
      );
      return;
    }

    setState(() {
      _dangTaoTaiKhoan = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    setState(() {
      _dangTaoTaiKhoan = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tạo tài khoản thành công')));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DangNhapScreen()),
      (route) => false,
    );
  }

  Widget _input({
    required TextEditingController controller,
    String? hintText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        filled: true,
        fillColor: const Color(0xFFFDFEFE),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF63D2DE)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const lightBlue = Color(0xFF46D7E7);
    const textDark = Color(0xFF26456E);
    const textGrey = Color(0xFF7F90A8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF9FC), Color(0xFFF8FCFD), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Setup Your Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete your account to start your journey.',
                      style: TextStyle(fontSize: 14, color: textGrey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE1E8F0)),
                          ),
                          child: const Text(
                            'Ảnh',
                            style: TextStyle(fontSize: 22, color: textDark),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profile Pictures',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Chưa cài chức năng upload ảnh',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.upload_outlined, size: 18),
                              label: const Text('Upload Photo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF303030),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _input(
                            controller: _hoController,
                            hintText: 'First Name',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _input(
                            controller: _tenController,
                            hintText: 'Last Name',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _input(
                      controller: _ngaySinhController,
                      hintText: 'Birth Date',
                      icon: Icons.calendar_month_outlined,
                    ),
                    const SizedBox(height: 12),
                    _input(controller: _quocGiaController, hintText: 'Country'),
                    const SizedBox(height: 12),
                    _input(controller: _tinhController, hintText: 'Province'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _input(
                            controller: _thanhPhoController,
                            hintText: 'City',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _input(
                            controller: _zipController,
                            hintText: 'Zip Code',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [primaryBlue, lightBlue],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _dangTaoTaiKhoan ? null : _taoTaiKhoan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _dangTaoTaiKhoan
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Start Your Journey',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DangNhapScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE1E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.w700,
                          ),
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
