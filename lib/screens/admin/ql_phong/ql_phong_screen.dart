import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import '../../../core/widgets/room_card_widget.dart';
import 'them_phong_screen.dart';
import 'chi_tiet_phong_screen.dart';

class QLPhongScreen extends StatefulWidget {
  const QLPhongScreen({Key? key}) : super(key: key);

  @override
  State<QLPhongScreen> createState() => _QLPhongScreenState();
}

class _QLPhongScreenState extends State<QLPhongScreen> {
  // Dữ liệu mẫu bám sát hình 3
  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Suite Room',
      'image': 'https://via.placeholder.com/400x200',
      'amenities': [
        {'icon': Icons.wifi, 'text': 'Wi-Fi miễn phí'},
        {'icon': Icons.landscape, 'text': 'Quang cảnh núi'},
        {'icon': Icons.restaurant, 'text': 'Gồm bữa sáng'},
        {'icon': Icons.smoke_free, 'text': 'Không hút thuốc'},
        {'icon': Icons.fitness_center, 'text': 'Fitness Center'},
        {'icon': Icons.king_bed_outlined, 'text': '1 giường cỡ queen'},
        {'icon': Icons.person_outline, 'text': '2 người lớn'},
      ],
      'price': 'VND 328.734',
      'total_text': 'Tổng: VND 379,689\nBao gồm thuế và phí',
    },
    {
      'name': 'Suite Room',
      'image': 'https://via.placeholder.com/400x200',
      'amenities': [
        {'icon': Icons.wifi, 'text': 'Wi-Fi miễn phí'},
        {'icon': Icons.landscape, 'text': 'Quang cảnh núi'},
        {'icon': Icons.restaurant_menu, 'text': 'Không gồm bữa sáng'},
        {'icon': Icons.smoke_free, 'text': 'Không hút thuốc'},
        {'icon': Icons.sports_gymnastics, 'text': 'Trung tâm thể thao'},
        {'icon': Icons.king_bed_outlined, 'text': '1 giường cỡ queen'},
        {'icon': Icons.person_outline, 'text': '2 người lớn'},
      ],
      'price': 'VND 328.734',
      'total_text': 'Tổng: VND 379,689\nBao gồm thuế và phí',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9), // Màu nền xanh nhạt
      appBar: const CustomAppBar(
        title: 'Danh sách phòng',
        showBackButton: false,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return _buildRoomCard(room);
        },
      ),
      // Nút thêm phòng nổi bật ở góc dưới
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemPhongScreen()),
          );
        },
        backgroundColor: const Color(0xFF75C8F2),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh phòng (Phần trên cùng)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              room['image'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey, size: 50),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên phòng
                Text(
                  room['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Danh sách tiện ích (Chia 2 cột)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 5, // Điều chỉnh tỷ lệ để vừa chữ
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: room['amenities'].length,
                  itemBuilder: (context, index) {
                    final amenity = room['amenities'][index];
                    return Row(
                      children: [
                        Icon(
                          amenity['icon'],
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            amenity['text'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 12),
                const Divider(), // Đường kẻ ngang phân cách
                const SizedBox(height: 8),

                // Phần Giá và Nút Chi tiết
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room['price'],
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          room['total_text'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChiTietPhongScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Chi tiết',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
