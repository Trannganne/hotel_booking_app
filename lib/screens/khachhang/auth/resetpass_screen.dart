import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hotel_booking_app/controllers/auth/AuthContronller.dart';

class QuenMatKhauScreen extends StatefulWidget {
  const QuenMatKhauScreen({
    super.key,
  });

  @override
  State<QuenMatKhauScreen> createState() => _QuenMatKhauScreenState();
}

class _QuenMatKhauScreenState extends State<QuenMatKhauScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future<void> _guiMail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await context.read<Authcontronller>().quenMatKhau(
            email: _emailController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Đã gửi email reset mật khẩu",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Lỗi: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<Authcontronller>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quên mật khẩu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nhập email";
                  }

                  if (!value.contains("@")) {
                    return "Email không hợp lệ";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _guiMail,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Gửi email"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}