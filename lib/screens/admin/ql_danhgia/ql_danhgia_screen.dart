import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import '../../../models/BaseModel/ReviewModel.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Dữ liệu mẫu ban đầu
  List<ReviewModel> allReviews = [
    ReviewModel(
      id: "1",
      bookingId: "B001",
      userId: "U001",
      rating: 5,
      content: "Excellent! Very satisfied.",
      createdAt: DateTime.now(),
      userAvatar: "https://m.yodycdn.com/blog/avatar-dep-cho-nam-yody-vn4.jpg",
      userName: "Nguyen Van A",
      images: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
      ],
    ),

    ReviewModel(
      id: "2",
      bookingId: "B002",
      userId: "U002",
      rating: 4,
      content: "Quite good, worth the price.",
      createdAt: DateTime.now(),
      userAvatar:
          "https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/avatar-dep-cho-nam-2.jpg",
      userName: "Tran Thi B",
    ),

    ReviewModel(
      id: "3",
      bookingId: "B003",
      userId: "U003",
      rating: 3,
      content: "A bit noisy.",
      createdAt: DateTime.now(),
      userAvatar:
          "https://i.pinimg.com/736x/58/5c/3b/585c3baa56d1384ff1b0b1e80c24bbe1.jpg",
      userName: "Le Van C",
      images: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiKP0L19lTUTFtsL9ZZgu4pVIJZwGGKSQYBg&s",
      ],
    ),

    ReviewModel(
      id: "4",
      bookingId: "B004",
      userId: "U004",
      rating: 3,
      content: "Average experience.",
      createdAt: DateTime.now(),
      userName: "Pham Thi D",
    ),

    ReviewModel(
      id: "5",
      bookingId: "B005",
      userId: "U005",
      rating: 3,
      content: "Room was okay but could be cleaner.",
      createdAt: DateTime.now(),
      userAvatar:
          "https://cdn.melodious.edu.vn/wp-content/uploads/2026/02/avatar-dep-cho-nu-cute-1.jpg",
      userName: "Hoang Van E",
    ),

    ReviewModel(
      id: "6",
      bookingId: "B006",
      userId: "U006",
      rating: 2,
      content: "Not very satisfied.",
      createdAt: DateTime.now(),
      userName: "Do Thi F",
    ),

    ReviewModel(
      id: "7",
      bookingId: "B007",
      userId: "U007",
      rating: 3,
      content: "Decent for short stay.",
      createdAt: DateTime.now(),
      userName: "Bui Van G",
    ),

    ReviewModel(
      id: "8",
      bookingId: "B008",
      userId: "U008",
      rating: 4,
      content: "Good service and friendly staff.",
      createdAt: DateTime.now(),
      userName: "Dang Thi H",
    ),
  ];

  int selectedStar = 0; // 0 nghĩa là hiển thị tất cả
  final TextEditingController _replyController = TextEditingController();

  // Hàm lọc danh sách
  List<ReviewModel> get filteredReviews {
    if (selectedStar == 0) return allReviews;
    return allReviews.where((r) => r.rating == selectedStar).toList();
  }

  // Hàm xử lý gửi phản hồi
  void _sendReply(String id) {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      final index = allReviews.indexWhere((element) => element.id == id);
      allReviews[index].adminReply = _replyController.text;
    });

    _replyController.clear();
    Navigator.pop(context); // Đóng bottom sheet
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã gửi phản hồi!")));
  }

  // Mở cửa sổ nhập phản hồi
  void _showReplyDialog(ReviewModel review) {
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
              onPressed: () => _sendReply(review.id.toString()),
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
      appBar: const CustomAppBar(title: "Quản lý đánh giá"),
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
