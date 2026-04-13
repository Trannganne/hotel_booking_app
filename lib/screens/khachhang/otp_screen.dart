import 'package:flutter/material.dart';
import 'setup_profile_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String matKhau;
  final String soDienThoai;

  const OtpScreen({
    Key? key,
    required this.email,
    required this.matKhau,
    required this.soDienThoai,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _tiepTuc() {
    final otp = _otpControllers.map((e) => e.text.trim()).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đủ mã OTP')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupProfileScreen(
          email: widget.email,
          matKhau: widget.matKhau,
          soDienThoai: widget.soDienThoai,
        ),
      ),
    );
  }

  Widget _otpBox(TextEditingController controller) {
    return SizedBox(
      width: 56,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFFDFEFE),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE1E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF63D2DE)),
          ),
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
                      'Enter Verification Code',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We have sent a code to number ${widget.soDienThoai}',
                      style: const TextStyle(fontSize: 14, color: textGrey),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _otpBox(_otpControllers[0]),
                        _otpBox(_otpControllers[1]),
                        _otpBox(_otpControllers[2]),
                        _otpBox(_otpControllers[3]),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                          onPressed: _tiepTuc,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: textGrey),
                          children: [
                            TextSpan(text: "Didn't receive the code? "),
                            TextSpan(
                              text: 'Resend the OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                          ],
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
