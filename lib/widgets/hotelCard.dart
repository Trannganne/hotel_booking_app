import 'package:flutter/material.dart';
import '../../core/widgets/custom_button.dart';

Widget buildHotelCard() {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 8,
    ), // Thêm margin để card không dính sát mép màn hình
    padding: const EdgeInsets.all(8), // Tăng padding một chút cho thoáng
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13), // Bo góc tròn hơn cho hiện đại
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05), // Đổ bóng nhẹ nhàng hơn
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // 1. Ảnh bên trái
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/images/test.jpg',
            width: 90, // Tăng kích thước ảnh một chút
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[300], width: 90, height: 90),
          ),
        ),

        const SizedBox(width: 16),

        // 2. Phần nội dung giữa và nút bên phải
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Đẩy text sang trái, nút sang phải
            crossAxisAlignment:
                CrossAxisAlignment.end, // Căn nút nằm dưới cùng hàng với text
            children: [
              // Cột chứa text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Phòng DeLuxe',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Chữ to rõ hơn
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '23/04 - 25/04/2026',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Chi tiết
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFBFDFFF,
                  ), // Màu xanh nhạt theo ảnh
                  foregroundColor: const Color(0xFF0066CC), // Màu chữ xanh đậm
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  elevation: 0, // Phẳng hoàn toàn theo style hiện đại
                ),
                onPressed: () {},
                child: const Text(
                  "Chi tiết",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
