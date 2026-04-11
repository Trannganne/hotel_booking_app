import 'package:flutter/material.dart';

class DoiMatKhauScreen extends StatefulWidget {
  const DoiMatKhauScreen({Key? key}) : super(key: key);

  @override
  State<DoiMatKhauScreen> createState() => _DoiMatKhauScreenState();
}

class _DoiMatKhauScreenState extends State<DoiMatKhauScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _matKhauHienTaiController = TextEditingController();
  final TextEditingController _matKhauMoiController = TextEditingController();
  final TextEditingController _xacNhanController = TextEditingController();

  bool _anMatKhauHienTai = true;
  bool _anMatKhauMoi = true;
  bool _anXacNhan = true;
  bool _dangXuLy = false;

  @override
  void dispose() {
    _matKhauHienTaiController.dispose();
    _matKhauMoiController.dispose();
    _xacNhanController.dispose();
    super.dispose();
  }

  void _doiMatKhau() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _dangXuLy = true);

    // Giả lập gọi API (bạn thay bằng API thật sau)
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _dangXuLy = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đổi mật khẩu thành công!'),
        backgroundColor: Color(0xFF2388E8),
      ),
    );

    // Quay lại màn hình trước
    Navigator.pop(context);
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
            colors: [
              Color(0xFFEAF9FC),
              Color(0xFFF8FCFD),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Tiêu đề
                      const Text(
                        'Đổi Mật Khẩu',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nhập mật khẩu hiện tại và mật khẩu mới của bạn.',
                        style: TextStyle(
                          fontSize: 14,
                          color: textGrey,
                        ),
                      ),

                      const SizedBox(height: 32),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // MẬT KHẨU HIỆN TẠI
                            _buildPasswordField(
                              controller: _matKhauHienTaiController,
                              hint: 'Mật khẩu hiện tại',
                              obscure: _anMatKhauHienTai,
                              onToggle: () => setState(() => _anMatKhauHienTai = !_anMatKhauHienTai),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu hiện tại';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // MẬT KHẨU MỚI
                            _buildPasswordField(
                              controller: _matKhauMoiController,
                              hint: 'Mật khẩu mới',
                              obscure: _anMatKhauMoi,
                              onToggle: () => setState(() => _anMatKhauMoi = !_anMatKhauMoi),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu mới';
                                }
                                if (value.length < 6) {
                                  return 'Ít nhất 6 ký tự';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // XÁC NHẬN MẬT KHẨU MỚI
                            _buildPasswordField(
                              controller: _xacNhanController,
                              hint: 'Xác nhận mật khẩu mới',
                              obscure: _anXacNhan,
                              onToggle: () => setState(() => _anXacNhan = !_anXacNhan),
                              validator: (value) {
                                if (value != _matKhauMoiController.text) {
                                  return 'Mật khẩu xác nhận không khớp';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // BUTTON CẬP NHẬT
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
                            onPressed: _dangXuLy ? null : _doiMatKhau,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _dangXuLy
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Cập nhật mật khẩu',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
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
      ),
    );
  }

  // Widget input mật khẩu tái sử dụng
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
        ),
        filled: true,
        fillColor: const Color(0xFFFDFEFE),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
}