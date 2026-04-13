import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/khachhang/dangky_screen.dart';
import 'resetpass_screen.dart';
import 'doimk_screen.dart'; // ← Đã thêm import này
import 'package:flutter/gestures.dart';
import '../khachhang/trangchu/trangchu_screen.dart';
import '../khachhang/main_screen.dart';
import '../admin/main_screen_admin.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DangNhapScreen(),
    );
  }
}

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

  final Color errorColor = const Color(0xFFE53935);

  @override
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  void _xuLyDangNhap() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loiMatKhau = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _dangXuLy = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailController.text.trim();
    final matKhau = _matKhauController.text.trim();
    // Demo đăng nhập admin
    if (email == 'admin@gmail.com' && matKhau == 'admin123') {
      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập admin thành công')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreenAdmin()),
      );
      return;
    } else
    // Demo đăng nhập khách hàng
    if (email == 'dhung@gmail.com' && matKhau == '12345678') {
      setState(() {
        _dangXuLy = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập khách hàng thành công')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      return;
    } else {
      setState(() {
        _dangXuLy = false;
        _loiMatKhau = 'Password Incorrect';
      });
      return;
    }
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

              // LOGO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.apartment, color: primaryBlue),
                  SizedBox(width: 6),
                  Text(
                    "HotelBank",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Welcome Back! 👋",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // EMAIL
                    _input(
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nhập email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // PASSWORD
                    _input(
                      controller: _matKhauController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: _anMatKhau,
                      errorText: _loiMatKhau,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            _anMatKhau = !_anMatKhau;
                          });
                        },
                        icon: Icon(
                          _anMatKhau ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nhập mật khẩu";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Forgot Password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),

              const SizedBox(height: 10),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [primaryBlue, lightBlue],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _dangXuLy ? null : _xuLyDangNhap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: _dangXuLy
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("LOGIN"),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              // GOOGLE BUTTON
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "G",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Continue with Google"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nút test Đổi mật khẩu
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoiMatKhauScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Đổi mật khẩu",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: "Sing Up",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DangKyScreen(),
                            ),
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
