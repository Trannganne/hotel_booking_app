import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../services/auth_service/auth_service.dart';
import '../taikhoan_kh/taikhoankh_screen.dart';

class SetupProfileScreen extends StatefulWidget {
  final String uid;
  final String email;

  const SetupProfileScreen({
    super.key,
    required this.uid,
    required this.email,
  });

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  // =========================
  // CLOUDINARY CONFIG
  // =========================
  static const String cloudName = "dk9lbpxhu";
  static const String uploadPreset = "avatar_unsigned";

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hoTenController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();

  final AuthService _authService = AuthService();

  File? _avatarFile;

  bool _dangLuu = false;

  @override
  void dispose() {
    _hoTenController.dispose();
    _sdtController.dispose();

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
  // Nếu không chọn ảnh thì trả về null
  // UserModel sẽ tự lấy avatar mặc định
  // =========================
  Future<String?> _uploadAvatarCloudinary() async {
    if (_avatarFile == null) {
      return null;
    }

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url);

    request.fields["upload_preset"] = uploadPreset;
    request.fields["folder"] = "avatars";
    request.fields["public_id"] = widget.uid;

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        _avatarFile!.path,
      ),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Cloudinary lỗi: $responseBody");
    }

    final data = jsonDecode(responseBody);

    final avatarUrl = data["secure_url"];

    if (avatarUrl == null) {
      throw Exception("Không lấy được link ảnh từ Cloudinary");
    }

    return avatarUrl;
  }

  // =========================
  // LƯU HỒ SƠ
  // =========================
  Future<void> _luuHoSo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _dangLuu = true;
    });

    try {
      final avatarUrl = await _uploadAvatarCloudinary();

      await _authService.luuThongTinUser(
        uid: widget.uid,
        fullName: _hoTenController.text.trim(),
        email: widget.email,
        phoneNumber: _sdtController.text.trim(),
        avatar: avatarUrl,
        role: "CUSTOMER",
      );

      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lưu thông tin thành công',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _authService.layThongBaoLoiFirebase(e),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _dangLuu = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lỗi lưu hồ sơ: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF2388E8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text(
          'Thiết lập hồ sơ',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 58,
                            backgroundColor: primary,
                            child: _avatarFile == null
                                ? const Icon(
                                    Icons.person,
                                    size: 65,
                                    color: Colors.white,
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      _avatarFile!,
                                      width: 116,
                                      height: 116,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: _dangLuu ? null : _chonAvatar,
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
                    ),

                    const SizedBox(height: 12),

                    TextButton.icon(
                      onPressed: _dangLuu ? null : _chonAvatar,
                      icon: const Icon(Icons.image),
                      label: const Text(
                        'Chọn ảnh đại diện',
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Hoàn tất hồ sơ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Bạn có thể chọn avatar hoặc bỏ qua để dùng ảnh mặc định',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      initialValue: widget.email,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _hoTenController,
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
                        hintText: 'Nhập họ tên',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }

                        if (value.trim().length < 2) {
                          return 'Họ tên quá ngắn';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _sdtController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        hintText: 'Nhập số điện thoại',
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập số điện thoại';
                        }

                        if (value.length < 9) {
                          return 'Số điện thoại không hợp lệ';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _dangLuu ? null : _luuHoSo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: _dangLuu
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Lưu thông tin',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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