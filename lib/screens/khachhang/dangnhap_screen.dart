import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';         
import 'resetpass_screen.dart';
import 'taikhoankh_screen.dart';     
import 'dangky_screen.dart';           

class DangNhapScreen extends StatefulWidget {
  const DangNhapScreen({Key? key}) : super(key: key);

  @override
  State<DangNhapScreen> createState() => _DangNhapScreenState();
}

class _DangNhapScreenState extends State<DangNhapScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();

  bool _anMatKhau = true;
  bool _dangXuLy = false;
  String? _loiMatKhau;

  @override
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  void _xuLyDangNhap() async {
    FocusScope.of(context).unfocus();
    setState(() => _loiMatKhau = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _dangXuLy = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailController.text.trim();
    final matKhau = _matKhauController.text.trim();

    if (email != 'dhung@gmail.com' || matKhau != '12345678') {
      setState(() {
        _dangXuLy = false;
        _loiMatKhau = 'Password Incorrect';
      });
      return;
    }

    setState(() => _dangXuLy = false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const lightBlue = Color(0xFF46D7E7);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.apartment, color: primaryBlue),
                  SizedBox(width: 6),
                  Text("HotelBank", style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Welcome Back! 👋", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Login to continue", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _input(controller: _emailController, hint: "Email", icon: Icons.email_outlined, validator: (v) => v?.isEmpty ?? true ? "Nhập email" : null),
                    const SizedBox(height: 12),
                    _input(
                      controller: _matKhauController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: _anMatKhau,
                      errorText: _loiMatKhau,
                      suffix: IconButton(
                        onPressed: () => setState(() => _anMatKhau = !_anMatKhau),
                        icon: Icon(_anMatKhau ? Icons.visibility : Icons.visibility_off),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? "Nhập mật khẩu" : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordScreen())),
                child: const Text("Forgot Password?"),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(colors: [primaryBlue, lightBlue]),
                  ),
                  child: ElevatedButton(
                    onPressed: _dangXuLy ? null : _xuLyDangNhap,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: _dangXuLy ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN"),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(children: const [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR")), Expanded(child: Divider())]),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("G", style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text("Continue with Google"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Link Sign Up - ĐÃ SỬA
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: "Sign Up",
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DangKyScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? errorText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}