import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import '../../../controllers/khachhang/danhgia_phanhoi/danhgia_controller.dart';
import '../../../models/BaseModel/ReviewModel.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewController _reviewController = ReviewController();
  bool _isLoading = true;
  int selectedStar = 0; // 0 nghĩa là hiển thị tất cả
  final TextEditingController _replyController = TextEditingController();

  List<ReviewModel> get allReviews => _reviewController.reviews;

  // Hàm lọc danh sách
  List<ReviewModel> get filteredReviews {
    if (selectedStar == 0) return allReviews;
    return allReviews.where((r) => r.rating == selectedStar).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    await _reviewController.getAll();
    setState(() {
      _isLoading = false;
    });
  }

  // Hàm xử lý gửi phản hồi
  void _sendReply(String id) async {
    final content = _replyController.text.trim();
    if (content.isEmpty || id.isEmpty) return;

    Navigator.pop(context); // Đóng bottom sheet trước khi cập nhật

    await _reviewController.updateReviewReply(id, content);

    setState(() {
      final index = allReviews.indexWhere((element) => element.id == id);
      if (index >= 0) {
        allReviews[index].adminReply = content;
      }
      _replyController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã gửi phản hồi!")));
  }

  // Mở cửa sổ nhập phản hồi
  void _showReplyDialog(ReviewModel review) {
    _replyController.text = review.adminReply ?? '';

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
              "Phản hồi cho ${review.userName}",
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
              onPressed: () => _sendReply(review.id ?? ''),
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
      appBar: const CustomAppBar(
        title: "QUẢN LÝ ĐÁNH GIÁ",
        showBackButton: false,
      ),
      body: Column(
        children: [
          // 1. Thanh lọc số sao
          _buildFilterBar(),

          // 2. Danh sách đánh giá
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : allReviews.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có đánh giá nào',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
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

  Widget _buildReviewItem(ReviewModel review) {
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
                  backgroundImage: NetworkImage(review.userAvatar ?? ""),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName ?? "Người dùng không xác định",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 14,
                            color: i < review.rating
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
            Text(review.content),
            // PHẦN HIỂN THỊ ẢNH ĐÁNH GIÁ (nếu có)
            if (review.images != null && review.images!.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 100, // CHiều cao khu vực hiển thị ảnh
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.images![index],
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

            if (review.adminReply != null)
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
                        "Admin: ${review.adminReply}",
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
