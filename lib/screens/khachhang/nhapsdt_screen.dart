import 'package:flutter/material.dart';
import 'otp_screen.dart';

class NhapSdtScreen extends StatefulWidget {
  final String email;
  final String matKhau;

  const NhapSdtScreen({Key? key, required this.email, required this.matKhau})
    : super(key: key);

  @override
  State<NhapSdtScreen> createState() => _NhapSdtScreenState();
}

class _NhapSdtScreenState extends State<NhapSdtScreen> {
  final TextEditingController _sdtController = TextEditingController();
  bool _dangGuiOtp = false;

  @override
  void dispose() {
    _sdtController.dispose();
    super.dispose();
  }

  void _guiOtp() async {
    final sdt = _sdtController.text.trim();
    if (sdt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
      );
      return;
    }

    setState(() => _dangGuiOtp = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _dangGuiOtp = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          email: widget.email,
          matKhau: widget.matKhau,
          soDienThoai: sdt,
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF9FC), Color(0xFFF8FCFD), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Add Phone Number',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We will sent an OTP Verification for you.',
                      style: TextStyle(fontSize: 14, color: textGrey),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _sdtController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+84',
                        hintStyle: const TextStyle(color: textGrey),
                        filled: true,
                        fillColor: const Color(0xFFFDFEFE),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE1E8F0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF63D2DE),
                          ),
                        ),
                      ),
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
                          onPressed: _dangGuiOtp ? null : _guiOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _dangGuiOtp
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Send me the OTP',
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
    );
  }
}
