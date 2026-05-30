import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'qlchitiet_khach_screen.dart';

class QuanLyKhachHangScreen extends StatefulWidget {
  const QuanLyKhachHangScreen({super.key});

  @override
  State<QuanLyKhachHangScreen> createState() => _QuanLyKhachHangScreenState();
}

class _QuanLyKhachHangScreenState extends State<QuanLyKhachHangScreen> {
  String _searchQuery = '';

  String _text(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    final text = value.toString().trim();

    if (text.isEmpty) return defaultValue;

    return text;
  }

  String _formatNgay(dynamic value) {
    if (value == null) return 'Chưa có';

    if (value is Timestamp) {
      final date = value.toDate();

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    if (value is String) {
      if (value.isEmpty) return 'Chưa có';
      return value;
    }

    return value.toString();
  }

  String _layChuCaiDau(String name) {
    final text = name.trim();

    if (text.isEmpty || text == 'Chưa cập nhật') {
      return '?';
    }

    return text.substring(0, 1).toUpperCase();
  }

  List<Map<String, dynamic>> _locDanhSach(List<QueryDocumentSnapshot> docs) {
    final keyword = _searchQuery.trim().toLowerCase();

    final list = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final fullName = _text(
        data['fullName'] ?? data['hoTen'],
        defaultValue: 'Chưa cập nhật',
      );

      final phoneNumber = _text(
        data['phoneNumber'] ?? data['soDienThoai'],
        defaultValue: '',
      );

      final role = _text(
        data['role'] ?? data['vaiTro'],
        defaultValue: 'CUSTOMER',
      );

      final createdAt = data['createdAt'] ?? data['ngayTao'];

      final trangThai = _text(
        data['trangThai'] ?? data['status'],
        defaultValue: 'ACTIVE',
      );

      return {
        'id': doc.id,
        'uid': _text(data['uid'], defaultValue: doc.id),
        'fullName': fullName,
        'email': _text(data['email'], defaultValue: ''),
        'phoneNumber': phoneNumber,
        'avatar': _text(data['avatar'], defaultValue: ''),
        'role': role,
        'createdAt': createdAt,
        'ngayDangKy': _formatNgay(createdAt),
        'trangThai': trangThai,

        // Các field phụ nếu sau này user cập nhật thêm
        'ngaySinh': _text(data['ngaySinh'], defaultValue: ''),
        'quocGia': _text(data['quocGia'], defaultValue: ''),
        'tinhThanh': _text(data['tinhThanh'], defaultValue: ''),
        'zipCode': _text(data['zipCode'], defaultValue: ''),
        'profileCompleted': data['profileCompleted'] == true,
      };
    }).where((kh) {
      final role = kh['role'].toString();

      final laKhachHang = role == 'CUSTOMER' || role == 'KHACH_HANG';

      if (!laKhachHang) return false;

      if (keyword.isEmpty) return true;

      final fullName = kh['fullName'].toString().toLowerCase();
      final email = kh['email'].toString().toLowerCase();
      final phoneNumber = kh['phoneNumber'].toString().toLowerCase();

      return fullName.contains(keyword) ||
          email.contains(keyword) ||
          phoneNumber.contains(keyword);
    }).toList();

    list.sort((a, b) {
      final aDate = a['createdAt'];
      final bDate = b['createdAt'];

      if (aDate is Timestamp && bDate is Timestamp) {
        return bDate.compareTo(aDate);
      }

      return 0;
    });

    return list;
  }

  Future<void> _doiTrangThaiKhachHang(
    String uid,
    String trangThaiHienTai,
  ) async {
    final trangThaiMoi = trangThaiHienTai == 'ACTIVE' ? 'LOCKED' : 'ACTIVE';

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'trangThai': trangThaiMoi,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _xacNhanDoiTrangThai(
    Map<String, dynamic> khachHang,
  ) async {
    final isActive = khachHang['trangThai'] == 'ACTIVE';

    final dongY = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isActive ? 'Khóa tài khoản' : 'Mở khóa tài khoản',
          ),
          content: Text(
            isActive
                ? 'Bạn có chắc muốn khóa tài khoản ${khachHang['fullName']} không?'
                : 'Bạn có chắc muốn mở khóa tài khoản ${khachHang['fullName']} không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );

    if (dongY != true) return;

    await _doiTrangThaiKhachHang(
      khachHang['uid'],
      khachHang['trangThai'],
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isActive
              ? 'Đã khóa tài khoản khách hàng'
              : 'Đã mở khóa tài khoản khách hàng',
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> kh) {
    const primaryBlue = Color(0xFF2388E8);

    final avatar = kh['avatar']?.toString() ?? '';
    final name = kh['fullName']?.toString() ?? '';

    if (avatar.isNotEmpty) {
      return CircleAvatar(
        radius: 26,
        backgroundColor: primaryBlue.withOpacity(0.1),
        backgroundImage: NetworkImage(avatar),
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: primaryBlue.withOpacity(0.1),
      child: Text(
        _layChuCaiDau(name),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const textDark = Color(0xFF26456E);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text(
          'Quản lý khách hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên, email hoặc số điện thoại...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Lỗi tải dữ liệu: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                final danhSachKhachHang = _locDanhSach(docs);

                if (danhSachKhachHang.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy khách hàng'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: danhSachKhachHang.length,
                  itemBuilder: (context, index) {
                    final kh = danhSachKhachHang[index];
                    final isActive = kh['trangThai'] == 'ACTIVE';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: _buildAvatar(kh),
                        title: Text(
                          kh['fullName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kh['email'].toString().isEmpty
                                  ? 'Chưa có email'
                                  : kh['email'],
                            ),
                            Text(
                              'SĐT: ${kh['phoneNumber'].toString().isEmpty ? 'Chưa có' : kh['phoneNumber']}',
                            ),
                            Text(
                              'Đăng ký: ${kh['ngayDangKy']}',
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'detail') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChiTietKhachHangScreen(khachHang: kh),
                                ),
                              );
                            }

                            if (value == 'lock') {
                              await _xacNhanDoiTrangThai(kh);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'detail',
                              child: Text('Xem chi tiết'),
                            ),
                            PopupMenuItem(
                              value: 'lock',
                              child: Text(
                                isActive ? 'Khóa tài khoản' : 'Mở khóa',
                              ),
                            ),
                          ],
                          child: Chip(
                            label: Text(
                              isActive ? 'Hoạt động' : 'Khóa',
                              style: TextStyle(
                                color: isActive ? Colors.green : Colors.red,
                              ),
                            ),
                            backgroundColor: isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChiTietKhachHangScreen(khachHang: kh),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}