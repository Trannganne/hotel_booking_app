import 'package:flutter/material.dart';
import 'nhapsdt_screen.dart';
import 'dangnhap_screen.dart';

class DangKyScreen extends StatefulWidget {
  const DangKyScreen({Key? key}) : super(key: key);

  @override
  State<DangKyScreen> createState() => _DangKyScreenState();
}

class _DangKyScreenState extends State<DangKyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();
  final TextEditingController _xacNhanController = TextEditingController();

  bool _anMatKhau = true;
  bool _anXacNhan = true;
  bool _dangXuLy = false;
  bool _dongY = false;

  String? _loiEmail;

  final Color errorColor = const Color(0xFFE53935);

  final List<String> emailDaTonTai = ['admin@gmail.com', 'dhung@gmail.com'];

  void _dangKy() async {
    FocusScope.of(context).unfocus();
    setState(() => _loiEmail = null);

    if (!_formKey.currentState!.validate()) return;

    if (!_dongY) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý điều khoản')),
      );
      return;
    }

    setState(() => _dangXuLy = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailController.text.trim();

    if (emailDaTonTai.contains(email)) {
      setState(() {
        _dangXuLy = false;
        _loiEmail = 'Email đã tồn tại';
      });
      return;
    }

    setState(() => _dangXuLy = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tạo tài khoản thành công')));

    // ====================== SỬA Ở ĐÂY ======================
    // Chuyển sang trang nhập số điện thoại
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NhapSdtScreen(
          email: email,
          matKhau: _matKhauController.text.trim(),
        ),
      ),
    );
    // =======================================================
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2388E8);
    const light = Color(0xFF46D7E7);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Register to continue",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _input(
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                      errorText: _loiEmail,
                      validator: (v) =>
                          v?.isEmpty ?? true ? "Nhập email" : null,
                      onChanged: (_) {
                        if (_loiEmail != null) setState(() => _loiEmail = null);
                      },
                    ),
                    const SizedBox(height: 12),
                    _input(
                      controller: _matKhauController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: _anMatKhau,
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _anMatKhau = !_anMatKhau),
                        icon: Icon(
                          _anMatKhau ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Nhập mật khẩu";
                        if (v.length < 6) return "Ít nhất 6 ký tự";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _input(
                      controller: _xacNhanController,
                      hint: "Confirm Password",
                      icon: Icons.lock_outline,
                      obscure: _anXacNhan,
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _anXacNhan = !_anXacNhan),
                        icon: Icon(
                          _anXacNhan ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      validator: (v) => v != _matKhauController.text
                          ? "Không khớp mật khẩu"
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _dongY,
                    onChanged: (v) => setState(() => _dongY = v!),
                  ),
                  const Expanded(child: Text("Tôi đồng ý điều khoản")),
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(colors: [primary, light]),
                  ),
                  child: ElevatedButton(
                    onPressed: _dangXuLy ? null : _dangKy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: _dangXuLy
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("REGISTER"),
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.blue),
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
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: errorText != null ? errorColor : const Color(0xFFE1E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: errorText != null ? errorColor : const Color(0xFF63D2DE),
          ),
        ),
      ),
    );
  }
}
