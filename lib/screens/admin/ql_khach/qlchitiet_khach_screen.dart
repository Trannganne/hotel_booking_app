import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChiTietKhachHangScreen extends StatelessWidget {
  final Map<String, dynamic> khachHang;

  const ChiTietKhachHangScreen({
    super.key,
    required this.khachHang,
  });

  String _text(dynamic value) {
    if (value == null) return 'Chưa có';
    final text = value.toString().trim();
    if (text.isEmpty) return 'Chưa có';
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

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const textDark = Color(0xFF26456E);

    final uid = khachHang['uid']?.toString() ?? khachHang['id']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Chi tiết khách hàng'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin cá nhân',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoRow('UID', _text(uid)),
                    _infoRow('Họ tên', _text(khachHang['hoTen'])),
                    _infoRow('Email', _text(khachHang['email'])),
                    _infoRow('Số điện thoại', _text(khachHang['sdt'])),
                    _infoRow('Ngày sinh', _text(khachHang['ngaySinh'])),
                    _infoRow('Quốc gia', _text(khachHang['quocGia'])),
                    _infoRow('Tỉnh / Thành phố', _text(khachHang['tinhThanh'])),
                    _infoRow('Zip code', _text(khachHang['zipCode'])),
                    _infoRow('Ngày đăng ký', _text(khachHang['ngayDangKy'])),
                    _infoRow(
                      'Trạng thái',
                      khachHang['trangThai'] == 'ACTIVE'
                          ? 'Hoạt động'
                          : 'Khóa',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lịch sử đặt phòng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Lỗi tải lịch sử: ${snapshot.error}'),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Chưa có lịch sử đặt phòng'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final maDat = data['maDat']?.toString() ?? docs[index].id;
                    final phong = data['phong']?.toString() ?? 'Chưa có phòng';
                    final checkIn = _formatNgay(data['checkIn']);
                    final checkOut = _formatNgay(data['checkOut']);
                    final gia = data['tongTien']?.toString() ?? '0';
                    final trangThai =
                        data['trangThai']?.toString() ?? 'Chưa xác định';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          'Mã đặt: $maDat - $phong',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check-in: $checkIn → Check-out: $checkOut'),
                            Text('Giá: $gia VNĐ'),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(trangThai),
                          backgroundColor: Colors.green.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.green),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}