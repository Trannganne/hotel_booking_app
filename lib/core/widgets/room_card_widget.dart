import 'package:flutter/material.dart';

class RoomCardWidget extends StatelessWidget {
  final Map<String, dynamic> room;
  final VoidCallback? onEdit;
  final VoidCallback? onLock;

  const RoomCardWidget({Key? key, required this.room, this.onEdit, this.onLock})
    : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'TRỐNG':
        return Colors.green;
      case 'ĐANG SỬ DỤNG':
        return Colors.orange;
      case 'BẢO TRÌ':
        return Colors.red;
      case 'ĐANG DỌN DẸP':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    room['so_phong'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(room['trang_thai']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    room['trang_thai'],
                    style: TextStyle(
                      color: _getStatusColor(room['trang_thai']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                'Loại: ${room['loai']}\nTầng: ${room['tang']}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: onEdit, // Gọi hàm callback
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  icon: const Icon(Icons.lock, color: Colors.grey, size: 20),
                  onPressed: onLock, // Gọi hàm callback
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
