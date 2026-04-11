import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import '../../widgets/hotelCard.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 5; // Mặc định 5 sao như ảnh
  final List<File> _selectedImages = [];
  final TextEditingController _reviewController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  final Color primaryBlue = const Color(0xFF22A3ED);

  Future<void> _pickImages() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Nền xanh đồng bộ với Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ĐÁNH GIÁ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
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
                    buildHotelCard(),
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
                onPressed: _isLoading ? null : () {}, // Logic của bạn
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
                GestureDetector(
                  onTap: _pickImages,
                  child: DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashPattern: const [8, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '+ ẢNH/ VIDEO',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Hiển thị Preview danh sách ảnh đã chọn
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImages[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Nút xóa ảnh nhanh (Option)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _selectedImages.removeAt(index),
                                ),
                                child: Container(
                                  color: Colors.black54,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

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
}
