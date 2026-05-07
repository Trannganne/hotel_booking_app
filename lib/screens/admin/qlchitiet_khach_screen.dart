import 'package:flutter/material.dart';

class ChiTietKhachHangScreen extends StatelessWidget {
  final Map<String, dynamic> khachHang;

  const ChiTietKhachHangScreen({Key? key, required this.khachHang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const textDark = Color(0xFF26456E);
    const textGrey = Color(0xFF7F90A8);

    // Dữ liệu lịch sử đặt phòng demo
    final List<Map<String, dynamic>> lichSuDatPhong = [
      {
        "maDat": "DP001",
        "phong": "Phòng Deluxe 101",
        "checkIn": "05/04/2025",
        "checkOut": "08/04/2025",
        "gia": "2,800,000",
        "trangThai": "Đã hoàn thành",
      },
      {
        "maDat": "DP002",
        "phong": "Phòng Standard 205",
        "checkIn": "12/04/2025",
        "checkOut": "15/04/2025",
        "gia": "1,950,000",
        "trangThai": "Đã hoàn thành",
      },
    ];

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
            // Thông tin cá nhân
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thông tin cá nhân", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                    const SizedBox(height: 16),
                    _infoRow("Họ tên", khachHang["hoTen"]),
                    _infoRow("Email", khachHang["email"]),
                    _infoRow("Số điện thoại", khachHang["sdt"]),
                    _infoRow("Ngày đăng ký", khachHang["ngayDangKy"]),
                    _infoRow("Trạng thái", khachHang["trangThai"]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lịch sử đặt phòng
            const Text("Lịch sử đặt phòng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lichSuDatPhong.length,
              itemBuilder: (context, index) {
                final ls = lichSuDatPhong[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text("Mã đặt: ${ls["maDat"]} - ${ls["phong"]}", style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Check-in: ${ls["checkIn"]} → Check-out: ${ls["checkOut"]}"),
                        Text("Giá: ${ls["gia"]} VNĐ"),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(ls["trangThai"]),
                      backgroundColor: Colors.green.withOpacity(0.1),
                      labelStyle: const TextStyle(color: Colors.green),
                    ),
                  ),
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
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}