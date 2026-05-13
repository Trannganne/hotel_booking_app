import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/ImagePickerWidget/ImagePickerWidget.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ReviewModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/screens/admin/main_screen_admin.dart';
import 'package:hotel_booking_app/widgets/review/RoomBookingCard.dart';
import 'dart:io';
import '../../../controllers/khachhang/danhgia_phanhoi/danhgia_controller.dart';

class RatingScreen extends StatefulWidget {
  final BookingModel booking;

  const RatingScreen({super.key, required this.booking});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // Khởi tạo controller để xử lý logic đánh giá

  final ReviewController reviewController = ReviewController();

  RoomTypeModel? roomType;

  //==================================================
  int _rating = 5; // Mặc định 5 sao
  final List<File> _selectedImages = [];
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  final Color primaryBlue = const Color(0xFF22A3ED);

  @override
  void initState() {
    super.initState();
    loadRoomType();
  }

  Future<void> loadRoomType() async {
    final result = await reviewController.getRoomType(
      widget.booking.roomTypeId,
    );

    if (!mounted) return;
    setState(() {
      roomType = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("RATING SCREEN BUILD");

    return Scaffold(
      backgroundColor: Colors.grey[100], // Nền xanh đồng bộ với Header
      appBar: const CustomAppBar(title: "Đánh giá"),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7F9), // Màu nền xám nhạt phía dưới
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- Card thông tin phòng ---
                    roomType == null
                        ? const Center(child: CircularProgressIndicator())
                        : RoomBookingCard(
                            roomName: roomType!.roomTypeName,
                            bookingDates:
                                "${formatDate(widget.booking.checkIn)} - "
                                "${formatDate(widget.booking.checkout)}",
                            imageUrl: roomType!.imagesList.first,
                            onDetailPressed: () {},
                          ),
                    const SizedBox(height: 16),

                    // --- Card đánh giá ---
                    _buildRatingForm(),
                  ],
                ),
              ),
            ),
          ),

          // --- Nút Gửi nằm dưới cùng ---
          Container(
            height: 80,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFF5F7F9),
            child: SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);

                        try {
                          final newReview = ReviewModel(
                            bookingId: widget.booking.id!,
                            userId: "",
                            rating: _rating,
                            content: _reviewController.text,
                            images: [],
                          );

                          await reviewController.submitReview(
                            newReview,
                            _selectedImages,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đánh giá đã được gửi!'),
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreenAdmin(),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          print(e);
                        }

                        setState(() => _isLoading = false);
                      }, // Logic của bạn
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0077FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Gửi',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingForm() {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 2, // Tạo độ nổi nhẹ cho Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RATING CỦA BẠN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Hàng sao có chức năng chọn (Rating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _rating = index + 1),
                      child: Icon(
                        Icons.star,
                        color: index < _rating
                            ? Colors.amber
                            : Colors.grey[300],
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                const Text(
                  'THÊM ẢNH (nếu có)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Khu vực chọn ảnh nét đứt (Dashed)
                ImagePickerWidget(
                  images: _selectedImages,
                  onChanged: (images) {
                    setState(() {
                      _selectedImages.clear();
                      _selectedImages.addAll(images);
                    });
                  },
                ),

                const SizedBox(height: 20),
                const Text(
                  'VIẾT ĐÁNH GIÁ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Ô nhập liệu đánh giá
                TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Nhập đánh giá của bạn...',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 201, 200, 200),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
