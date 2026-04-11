import 'package:flutter/material.dart';
import 'dangnhap_screen.dart'; // Quay về màn hình đăng nhập sau khi reset thành công

// ==============================================
// MARK: - ResetPasswordScreen (Quên mật khẩu)
// Nhập email để nhận link/code reset
// ==============================================
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _dangGui = false;
  String? _loiEmail;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _guiResetPassword() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loiEmail = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _dangGui = true;
    });

    // Giả lập gọi API (bạn thay bằng API thật sau)
    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailController.text.trim();

    setState(() {
      _dangGui = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chúng tôi đã gửi hướng dẫn đặt lại mật khẩu đến email của bạn'),
        backgroundColor: Color(0xFF2388E8),
      ),
    );

    // Tự động quay về màn hình đăng nhập sau 1.5 giây
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DangNhapScreen()),
          (route) => false,
        );
      }
    });
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
                      const SizedBox(height: 40),

                      // Icon reset password (giống phong cách minh họa của app)
                      Center(
                        child: Icon(
                          Icons.lock_reset_rounded,
                          size: 80,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Enter your email and we will send you instructions to reset your password.',
                        style: TextStyle(
                          fontSize: 14,
                          color: textGrey,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            hintStyle: const TextStyle(color: textGrey),
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: const Color(0xFFFDFEFE),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF63D2DE)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFE53935)),
                            ),
                            errorText: _loiEmail,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!value.contains('@')) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Button Send
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
                            onPressed: _dangGui ? null : _guiResetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _dangGui
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Send Reset Link',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Back to Login
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Back to Login',
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w600,
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
}

// ==============================================
// MARK: - NewPasswordScreen (Đặt mật khẩu mới)
// Màn hình sau khi người dùng click link / OTP
// ==============================================
class NewPasswordScreen extends StatefulWidget {
  final String email; // Có thể dùng sau này để hiển thị

  const NewPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _matKhauController = TextEditingController();
  final TextEditingController _xacNhanController = TextEditingController();

  bool _anMatKhau = true;
  bool _anXacNhan = true;
  bool _dangXuLy = false;

  @override
  void dispose() {
    _matKhauController.dispose();
    _xacNhanController.dispose();
    super.dispose();
  }

  void _datMatKhauMoi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _dangXuLy = true);

    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _dangXuLy = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mật khẩu đã được đặt lại thành công!')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DangNhapScreen()),
      (route) => false,
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
                      const SizedBox(height: 40),
                      const Text(
                        'Create New Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your new password must be different from previous used passwords.',
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
                            // Mật khẩu mới
                            _buildPasswordField(
                              controller: _matKhauController,
                              hint: 'New Password',
                              obscure: _anMatKhau,
                              onToggle: () => setState(() => _anMatKhau = !_anMatKhau),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Nhập mật khẩu mới';
                                if (value.length < 6) return 'Ít nhất 6 ký tự';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Xác nhận mật khẩu
                            _buildPasswordField(
                              controller: _xacNhanController,
                              hint: 'Confirm New Password',
                              obscure: _anXacNhan,
                              onToggle: () => setState(() => _anXacNhan = !_anXacNhan),
                              validator: (value) {
                                if (value != _matKhauController.text) {
                                  return 'Mật khẩu xác nhận không khớp';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Button Reset Password
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
                            onPressed: _dangXuLy ? null : _datMatKhauMoi,
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
                                    'Reset Password',
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

  // Widget input mật khẩu tái sử dụng (giống dangky_screen)
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