import 'package:flutter/material.dart';
import 'doimk_screen.dart';
import 'dangnhap_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  // Thông tin cá nhân
  String hoTen = "Đặng Hoàng Hưng";
  String email = "dhung@gmail.com";
  String soDienThoai = "+84 912 345 678";
  String ngaySinh = "15/08/1998";
  String quocGia = "Việt Nam";
  String tinhThanh = "Bà Rịa - Vũng Tàu";

  // Controllers cho chế độ chỉnh sửa
  late final TextEditingController _hoTenController;
  late final TextEditingController _emailController;
  late final TextEditingController _sdtController;
  late final TextEditingController _ngaySinhController;
  late final TextEditingController _quocGiaController;
  late final TextEditingController _tinhThanhController;

  @override
  void initState() {
    super.initState();
    _hoTenController = TextEditingController(text: hoTen);
    _emailController = TextEditingController(text: email);
    _sdtController = TextEditingController(text: soDienThoai);
    _ngaySinhController = TextEditingController(text: ngaySinh);
    _quocGiaController = TextEditingController(text: quocGia);
    _tinhThanhController = TextEditingController(text: tinhThanh);
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _emailController.dispose();
    _sdtController.dispose();
    _ngaySinhController.dispose();
    _quocGiaController.dispose();
    _tinhThanhController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // Lưu thông tin
      setState(() {
        hoTen = _hoTenController.text.trim();
        email = _emailController.text.trim();
        soDienThoai = _sdtController.text.trim();
        ngaySinh = _ngaySinhController.text.trim();
        quocGia = _quocGiaController.text.trim();
        tinhThanh = _tinhThanhController.text.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thông tin thành công!')),
      );
    }
    setState(() => _isEditing = !_isEditing);
  }

  void _cancelEdit() {
    _hoTenController.text = hoTen;
    _emailController.text = email;
    _sdtController.text = soDienThoai;
    _ngaySinhController.text = ngaySinh;
    _quocGiaController.text = quocGia;
    _tinhThanhController.text = tinhThanh;
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const lightBlue = Color(0xFF46D7E7);
    const textDark = Color(0xFF26456E);
    const textGrey = Color(0xFF7F90A8);   // ← Đã di chuyển lên đây để dùng chung

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE1E8F0), width: 4),
                        ),
                        child: const Center(
                          child: Text("HH", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textDark)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(hoTen, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textDark)),
                      Text(email, style: TextStyle(fontSize: 15, color: textGrey)),

                      const SizedBox(height: 40),

                      // Các trường thông tin
                      _buildField(Icons.person_outline, "Họ và tên", _hoTenController, _isEditing, textGrey),
                      _buildField(Icons.email_outlined, "Email", _emailController, _isEditing, textGrey),
                      _buildField(Icons.phone_outlined, "Số điện thoại", _sdtController, _isEditing, textGrey),
                      _buildField(Icons.cake_outlined, "Ngày sinh", _ngaySinhController, _isEditing, textGrey),
                      _buildField(Icons.public, "Quốc gia", _quocGiaController, _isEditing, textGrey),
                      _buildField(Icons.location_on_outlined, "Tỉnh/Thành phố", _tinhThanhController, _isEditing, textGrey),

                      const SizedBox(height: 40),

                      // Nút Chỉnh sửa / Lưu
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [primaryBlue, lightBlue]),
                          ),
                          child: ElevatedButton(
                            onPressed: _toggleEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              _isEditing ? 'Lưu thay đổi' : 'Chỉnh sửa thông tin',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      if (_isEditing) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _cancelEdit,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE1E8F0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Hủy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textGrey)),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Đổi mật khẩu
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoiMatKhauScreen())),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE1E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Đổi mật khẩu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textDark)),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Đăng xuất
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const DangNhapScreen()),
                            (route) => false,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE53935)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Đăng xuất', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFE53935))),
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

  // Widget xây dựng mỗi dòng thông tin
  Widget _buildField(IconData icon, String label, TextEditingController controller, bool isEditing, Color textGrey) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF63D2DE), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: TextStyle(fontSize: 13, color: textGrey)),
                      const SizedBox(height: 2),
                      Text(controller.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF26456E))),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}