import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'them_phong_screen.dart';
import 'chinh_sua_phong_screen.dart';

class ChiTietPhongScreen extends StatelessWidget {
  const ChiTietPhongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Chi tiết phòng", showBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh phòng
            Image.network(
              'https://via.placeholder.com/600x300',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. THÔNG TIN CƠ BẢN ---
                  const Text(
                    'Suite Có Tầm Nhìn Ra Núi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text(
                        '20.0 m²',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 32),
                      Text(
                        '1 giường cỡ queen',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Không bao gồm bữa sáng',
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                          Text(
                            '2 khách/phòng',
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'VND 328.734',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/phòng/đêm,\nChưa bao gồm thuế và phí',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // --- 2. CHÍNH SÁCH HỦY PHÒNG ---
                  const Text(
                    'Chính sách hủy phòng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildPolicyChip('Không hoàn tiền'),
                      const SizedBox(width: 12),
                      _buildPolicyChip('Đổi lịch'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                      children: const [
                        TextSpan(text: 'Đặt phòng này '),
                        TextSpan(
                          text: 'có thể hoàn tiền và không thể đổi lịch',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // --- 3. TIỆN NGHI PHÒNG ---
                  const Text(
                    'Phòng tiện nghi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletList([
                    'Máy lạnh',
                    'Nước đóng chai miễn phí',
                    'TV',
                    'Bàn làm việc',
                  ]),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // --- 4. TRANG BỊ PHÒNG TẮM ---
                  const Text(
                    'Trang bị phòng tắm',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletList([
                    'Nước nóng',
                    'Phòng tắm riêng',
                    'Vòi tắm đứng',
                    'Bộ vệ sinh cá nhân',
                    'Áo choàng tắm',
                    'Máy sấy tóc',
                  ]),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // --- 5. TỔNG GIÁ ---
            Container(
              width: double.infinity,
              color: const Color(0xFFF9F9F9), // Màu xám rất nhạt
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VND 379,689',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Giá cuối cùng',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),

            // --- 6. QUẢN LÝ TRẠNG THÁI (Các nút chức năng của Admin) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quản lý trạng thái phòng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          title: 'Xóa phòng',
                          color: const Color(0xFFE32539), // Màu đỏ
                          onPressed: () {
                            // Xử lý Xóa
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          title: 'Khóa Phòng',
                          color: Colors.grey.shade600, // Màu xám
                          onPressed: () {
                            // Xử lý Khóa
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          title: 'Chỉnh sửa',
                          color: const Color(0xFF4DB6F5),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChinhSuaPhongScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Padding dưới cùng để không bị sát lề
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo Chip cho Chính sách
  Widget _buildPolicyChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      ),
    );
  }

  // Widget tạo danh sách Bullet (dấu chấm)
  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '. ',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Widget tạo Button quản lý
  Widget _buildActionButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: FittedBox(
        // Giúp text không bị tràn nếu màn hình nhỏ
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
