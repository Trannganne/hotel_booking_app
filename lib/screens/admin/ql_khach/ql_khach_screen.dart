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
    if (text.isEmpty) return '?';
    return text.substring(0, 1).toUpperCase();
  }

  List<Map<String, dynamic>> _locDanhSach(List<QueryDocumentSnapshot> docs) {
    final keyword = _searchQuery.trim().toLowerCase();

    final list = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return {
        'id': doc.id,
        'uid': data['uid']?.toString() ?? doc.id,
        'hoTen': data['hoTen']?.toString() ?? 'Chưa cập nhật',
        'email': data['email']?.toString() ?? '',
        'sdt': data['soDienThoai']?.toString() ?? '',
        'ngaySinh': data['ngaySinh']?.toString() ?? '',
        'quocGia': data['quocGia']?.toString() ?? '',
        'tinhThanh': data['tinhThanh']?.toString() ?? '',
        'zipCode': data['zipCode']?.toString() ?? '',
        'ngayDangKy': _formatNgay(data['ngayTao']),
        'trangThai': data['trangThai']?.toString() ?? 'ACTIVE',
        'vaiTro': data['vaiTro']?.toString() ?? 'KHACH_HANG',
        'profileCompleted': data['profileCompleted'] == true,
      };
    }).where((kh) {
      if (keyword.isEmpty) return true;

      final hoTen = kh['hoTen'].toString().toLowerCase();
      final email = kh['email'].toString().toLowerCase();
      final sdt = kh['sdt'].toString().toLowerCase();

      return hoTen.contains(keyword) ||
          email.contains(keyword) ||
          sdt.contains(keyword);
    }).toList();

    return list;
  }

  Future<void> _doiTrangThaiKhachHang(
    String uid,
    String trangThaiHienTai,
  ) async {
    final trangThaiMoi = trangThaiHienTai == 'ACTIVE' ? 'LOCKED' : 'ACTIVE';

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'trangThai': trangThaiMoi,
      'ngayCapNhat': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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
                  .where('vaiTro', isEqualTo: 'KHACH_HANG')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Lỗi tải dữ liệu: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                        leading: CircleAvatar(
                          backgroundColor: primaryBlue.withOpacity(0.1),
                          child: Text(
                            _layChuCaiDau(kh['hoTen'].toString()),
                            style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          kh['hoTen'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(kh['email']),
                            Text(
                              'SĐT: ${kh['sdt'].toString().isEmpty ? 'Chưa có' : kh['sdt']}',
                            ),
                            Text('Đăng ký: ${kh['ngayDangKy']}'),
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
                              await _doiTrangThaiKhachHang(
                                kh['uid'],
                                kh['trangThai'],
                              );
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