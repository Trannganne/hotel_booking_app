import 'package:flutter/material.dart';
import '../../models/danhgia_model.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Dữ liệu mẫu ban đầu
  List<DanhGia> allReviews = [
    DanhGia(
      maDanhGia: 1,
      maDatPhong: 1,
      maTaiKhoan: 1,
      soSao: 5,
      noiDung: "Tuyệt vời!",
      ngayTao: DateTime.now(),
      avatar: "https://m.yodycdn.com/blog/avatar-dep-cho-nam-yody-vn4.jpg",
      danhSachAnh: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
      ],
    ),
    DanhGia(
      maDanhGia: 2,
      maDatPhong: 2,
      maTaiKhoan: 2,
      soSao: 4,
      noiDung: "Khá ổn",
      ngayTao: DateTime.now(),
      avatar:
          "https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-dep-cho-nam-2.jpg",
    ),

    DanhGia(
      maDanhGia: 3,
      maDatPhong: 3,
      maTaiKhoan: 3,
      soSao: 3,
      noiDung: "Hơi ồn",
      ngayTao: DateTime.now(),
      avatar:
          "https://i.pinimg.com/736x/58/5c/3b/585c3baa56d1384ff1b0b1e80c24bbe1.jpg",
      danhSachAnh: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s"
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
      ],
    ),

    DanhGia(
      maDanhGia: 3,
      maDatPhong: 3,
      maTaiKhoan: 3,
      soSao: 3,
      noiDung: "Hơi ồn",
      ngayTao: DateTime.now(),
    ),

    DanhGia(
      maDanhGia: 3,
      maDatPhong: 3,
      maTaiKhoan: 3,
      soSao: 3,
      noiDung: "Hơi ồn",
      ngayTao: DateTime.now(),
      avatar:
          "https://cdn.melodious.edu.vn/wp-content/uploads/2026/02/avatar-dep-cho-nu-cute-1.jpg",
    ),

    DanhGia(
      maDanhGia: 3,
      maDatPhong: 3,
      maTaiKhoan: 3,
      soSao: 3,
      noiDung: "Hơi ồn",
      ngayTao: DateTime.now(),
    ),

    DanhGia(
      maDanhGia: 3,
      maDatPhong: 3,
      maTaiKhoan: 3,
      soSao: 3,
      noiDung: "Hơi ồn",
      ngayTao: DateTime.now(),
    ),

    DanhGia(
      maDanhGia: 3,
      maDatPhong: 3,
      maTaiKhoan: 3,
      soSao: 3,
      noiDung: "Hơi ồn",
      ngayTao: DateTime.now(),
    ),
  ];

  int selectedStar = 0; // 0 nghĩa là hiển thị tất cả
  final TextEditingController _replyController = TextEditingController();

  // Hàm lọc danh sách
  List<DanhGia> get filteredReviews {
    if (selectedStar == 0) return allReviews;
    return allReviews.where((r) => r.soSao == selectedStar).toList();
  }

  // Hàm xử lý gửi phản hồi
  void _sendReply(String id) {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      final index = allReviews.indexWhere((element) => element.maDanhGia == id);
      allReviews[index].phanHoiAdmin = _replyController.text;
    });

    _replyController.clear();
    Navigator.pop(context); // Đóng bottom sheet
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã gửi phản hồi!")));
  }

  // Mở cửa sổ nhập phản hồi
  void _showReplyDialog(DanhGia review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Phản hồi cho ${review.tenNguoiDung}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _replyController,
              decoration: const InputDecoration(
                hintText: "Nhập nội dung phản hồi...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _sendReply(review.maDanhGia.toString()),
              child: const Text("Gửi phản hồi"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý Đánh giá",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Column(
        children: [
          // 1. Thanh lọc số sao
          _buildFilterBar(),

          // 2. Danh sách đánh giá
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredReviews.length,
              itemBuilder: (context, index) {
                final review = filteredReviews[index];
                return _buildReviewItem(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [0, 5, 4, 3, 2, 1].map((star) {
          bool isSelected = selectedStar == star;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(star == 0 ? "Tất cả" : "$star Sao"),
              selected: isSelected,
              onSelected: (val) => setState(() => selectedStar = star),
              selectedColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewItem(DanhGia review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(review.avatar ?? ""),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.tenNguoiDung ?? "Người dùng không xác định",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 14,
                            color: i < review.soSao
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Nút Phản hồi (Admin thấy)
                TextButton.icon(
                  onPressed: () => _showReplyDialog(review),
                  icon: const Icon(Icons.reply, size: 18),
                  label: const Text("Phản hồi"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(review.noiDung),
            // PHẦN HIỂN THỊ ẢNH ĐÁNH GIÁ (nếu có)
            if (review.danhSachAnh != null &&
                review.danhSachAnh!.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 100, // CHiều cao khu vực hiển thị ảnh
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.danhSachAnh!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.danhSachAnh![index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,

                          // Thêm loading và error handling
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            if (review.phanHoiAdmin != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                color: Colors.blue.withOpacity(0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.subdirectory_arrow_right,
                      size: 18,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Admin: ${review.phanHoiAdmin}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
