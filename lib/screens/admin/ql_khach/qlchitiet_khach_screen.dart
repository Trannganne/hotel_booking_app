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

  Widget _buildAvatar() {
    const primaryBlue = Color(0xFF2388E8);

    final avatar = khachHang['avatar']?.toString() ?? '';
    final name = khachHang['fullName']?.toString() ?? '';

    if (avatar.isNotEmpty) {
      return CircleAvatar(
        radius: 45,
        backgroundColor: primaryBlue.withOpacity(0.1),
        backgroundImage: NetworkImage(avatar),
      );
    }

    return CircleAvatar(
      radius: 45,
      backgroundColor: primaryBlue.withOpacity(0.1),
      child: Text(
        name.isEmpty ? '?' : name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Color _mauTrangThai(String trangThai) {
    if (trangThai == 'ACTIVE') return Colors.green;
    if (trangThai == 'LOCKED') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const textDark = Color(0xFF26456E);

    // UID chỉ dùng nội bộ để lấy lịch sử đặt phòng, không hiển thị ra giao diện
    final uid = khachHang['uid']?.toString() ?? khachHang['id']?.toString();

    final fullName = khachHang['fullName']?.toString();
    final phoneNumber = khachHang['phoneNumber']?.toString();
    final role = khachHang['role']?.toString();
    final trangThai = khachHang['trangThai']?.toString() ?? 'ACTIVE';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),

            const SizedBox(height: 12),

            Text(
              _text(fullName),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),

            const SizedBox(height: 6),

            Chip(
              label: Text(
                trangThai == 'ACTIVE' ? 'Hoạt động' : 'Khóa',
                style: TextStyle(
                  color: _mauTrangThai(trangThai),
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: _mauTrangThai(trangThai).withOpacity(0.1),
            ),

            const SizedBox(height: 20),

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

                    _infoRow('Họ tên', _text(fullName)),
                    _infoRow('Email', _text(khachHang['email'])),
                    _infoRow('Số điện thoại', _text(phoneNumber)),
                    _infoRow('Vai trò', _text(role)),
                    _infoRow('Ngày đăng ký', _text(khachHang['ngayDangKy'])),
                    _infoRow(
                      'Trạng thái',
                      trangThai == 'ACTIVE' ? 'Hoạt động' : 'Khóa',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lịch sử đặt phòng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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

                    final phong = data['phong']?.toString() ??
                        data['roomName']?.toString() ??
                        'Chưa có phòng';

                    final checkIn = _formatNgay(
                      data['checkIn'] ?? data['ngayNhanPhong'],
                    );

                    final checkOut = _formatNgay(
                      data['checkOut'] ?? data['ngayTraPhong'],
                    );

                    final gia = data['tongTien']?.toString() ??
                        data['total']?.toString() ??
                        '0';

                    final bookingStatus = data['trangThai']?.toString() ??
                        data['status']?.toString() ??
                        'Chưa xác định';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          'Mã đặt: $maDat - $phong',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check-in: $checkIn → Check-out: $checkOut'),
                            Text('Giá: $gia VNĐ'),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(bookingStatus),
                          backgroundColor: Colors.green.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: Colors.green,
                          ),
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
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}