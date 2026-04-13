import 'package:flutter/material.dart';
import 'qlchitiet_khach_screen.dart';

class QuanLyKhachHangScreen extends StatefulWidget {
  const QuanLyKhachHangScreen({Key? key}) : super(key: key);

  @override
  State<QuanLyKhachHangScreen> createState() => _QuanLyKhachHangScreenState();
}

class _QuanLyKhachHangScreenState extends State<QuanLyKhachHangScreen> {
  String _searchQuery = "";

  // dữ liệu mẫu , sau này thay bằng dữ liệu db
  final List<Map<String, dynamic>> _danhSachKhachHang = [
    {
      "id": "KH001",
      "hoTen": "Nguyễn Văn An",
      "email": "an.nguyen@gmail.com",
      "sdt": "0912345678",
      "ngayDangKy": "12/03/2025",
      "trangThai": "Hoạt động",
    },
    {
      "id": "KH002",
      "hoTen": "Trần Thị Bình",
      "email": "binh.tran@gmail.com",
      "sdt": "0987654321",
      "ngayDangKy": "15/03/2025",
      "trangThai": "Hoạt động",
    },
    {
      "id": "KH003",
      "hoTen": "Lê Hoàng Cường",
      "email": "cuong.le@gmail.com",
      "sdt": "0978123456",
      "ngayDangKy": "20/03/2025",
      "trangThai": "Khóa",
    },
    {
      "id": "KH004",
      "hoTen": "Phạm Thị Dung",
      "email": "dung.pham@gmail.com",
      "sdt": "0933456789",
      "ngayDangKy": "25/03/2025",
      "trangThai": "Hoạt động",
    },
  ];

  List<Map<String, dynamic>> get filteredList {
    if (_searchQuery.isEmpty) return _danhSachKhachHang;
    return _danhSachKhachHang.where((kh) {
      return kh["hoTen"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             kh["email"].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2388E8);
    const textDark = Color(0xFF26456E);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        title: const Text('Quản lý khách hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Tìm kiếm theo tên hoặc email...",
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
            child: filteredList.isEmpty
                ? const Center(child: Text("Không tìm thấy khách hàng"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final kh = filteredList[index];
                      final isActive = kh["trangThai"] == "Hoạt động";

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: primaryBlue.withOpacity(0.1),
                            child: Text(
                              kh["hoTen"].substring(0, 1),
                              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(kh["hoTen"], style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(kh["email"]),
                              Text("SĐT: ${kh["sdt"]}"),
                              Text("Đăng ký: ${kh["ngayDangKy"]}"),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(kh["trangThai"], style: TextStyle(color: isActive ? Colors.green : Colors.red)),
                            backgroundColor: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChiTietKhachHangScreen(khachHang: kh),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}