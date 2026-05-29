import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/auth/AuthContronller.dart';
import 'dangnhap_screen.dart';
import 'verify_email_screen.dart';

class DangKyScreen extends StatefulWidget {
  const DangKyScreen({super.key});

  @override
  State<DangKyScreen> createState() => _DangKyScreenState();
}

class _DangKyScreenState extends State<DangKyScreen> {
  // =========================
  // CLOUDINARY CONFIG
  // =========================
  static const String cloudName = "dk9lbpxhu";
  static const String uploadPreset = "avatar_unsigned";

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  File? _avatarFile;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _dangUploadAvatar = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================
  // CHỌN AVATAR
  // =========================
  Future<void> _chonAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (pickedFile == null) {
        return;
      }

      setState(() {
        _avatarFile = File(pickedFile.path);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã chọn ảnh đại diện'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi chọn ảnh: $e'),
        ),
      );
    }
  }

  // =========================
  // UPLOAD AVATAR LÊN CLOUDINARY
  // =========================
  Future<String?> _uploadAvatarCloudinary(String uid) async {
    if (_avatarFile == null) {
      return null;
    }

    try {
      setState(() {
        _dangUploadAvatar = true;
      });

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest("POST", url);

      request.fields["upload_preset"] = uploadPreset;
      request.fields["folder"] = "avatars";
      request.fields["public_id"] = uid;

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          _avatarFile!.path,
        ),
      );

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(responseBody);
      }

      final data = jsonDecode(responseBody);

      final avatarUrl = data["secure_url"];

      if (avatarUrl == null) {
        throw Exception("Không lấy được link ảnh từ Cloudinary");
      }

      if (mounted) {
        setState(() {
          _dangUploadAvatar = false;
        });
      }

      return avatarUrl;
    } catch (e) {
      if (mounted) {
        setState(() {
          _dangUploadAvatar = false;
        });
      }

      throw Exception("Lỗi upload avatar Cloudinary: $e");
    }
  }

  // =========================
  // ĐĂNG KÝ
  // =========================
  Future<void> _dangKy() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final authController = context.read<Authcontronller>();

      // 1. Đăng ký Firebase Auth + lưu thông tin user cơ bản
      await authController.dangKyUser(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = authController.uid;

      if (uid == null) {
        throw Exception("Không lấy được UID người dùng");
      }

      // 2. Nếu có chọn avatar thì upload lên Cloudinary
      final avatarUrl = await _uploadAvatarCloudinary(uid);

      // 3. Nếu upload thành công thì cập nhật avatar vào Firestore
      if (avatarUrl != null) {
        await authController.capNhatProfile(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          avatar: avatarUrl,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Đăng ký thành công. Vui lòng xác minh email",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            uid: uid,
            email: _emailController.text.trim(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangUploadAvatar = false;
      });

      final authController = context.read<Authcontronller>();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authController.layThongBaoLoiFirebase(e),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangUploadAvatar = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Lỗi đăng ký: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    final isLoading = context.watch<Authcontronller>().isLoading;
    final dangXuLy = isLoading || _dangUploadAvatar;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.hotel,
                      size: 80,
                      color: primary,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Đăng ký tài khoản',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Tạo tài khoản để đặt phòng khách sạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // AVATAR
                    // =========================
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: primary,
                          child: _avatarFile == null
                              ? const Icon(
                                  Icons.person,
                                  size: 55,
                                  color: Colors.white,
                                )
                              : ClipOval(
                                  child: Image.file(
                                    _avatarFile!,
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: dangXuLy ? null : _chonAvatar,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: dangXuLy ? null : _chonAvatar,
                      icon: const Icon(Icons.image),
                      label: const Text(
                        'Chọn ảnh đại diện',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // HỌ TÊN
                    // =========================
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Họ và tên',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nhập họ tên';
                        }

                        if (value.trim().length < 2) {
                          return 'Họ tên quá ngắn';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // SỐ ĐIỆN THOẠI
                    // =========================
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Số điện thoại',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nhập số điện thoại';
                        }

                        if (value.trim().length < 9) {
                          return 'Số điện thoại không hợp lệ';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // EMAIL
                    // =========================
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nhập email';
                        }

                        if (!value.contains('@')) {
                          return 'Email không hợp lệ';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // MẬT KHẨU
                    // =========================
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: dangXuLy
                              ? null
                              : () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập mật khẩu';
                        }

                        if (value.length < 6) {
                          return 'Tối thiểu 6 ký tự';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // XÁC NHẬN MẬT KHẨU
                    // =========================
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          onPressed: dangXuLy
                              ? null
                              : () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Xác nhận mật khẩu';
                        }

                        if (value != _passwordController.text) {
                          return 'Mật khẩu không khớp';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // =========================
                    // BUTTON ĐĂNG KÝ
                    // =========================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: dangXuLy ? null : _dangKy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                        ),
                        child: dangXuLy
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Đăng ký',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Đã có tài khoản?'),
                        TextButton(
                          onPressed: dangXuLy
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DangNhapScreen(),
                                    ),
                                  );
                                },
                          child: const Text('Đăng nhập'),
                        ),
                      ],
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