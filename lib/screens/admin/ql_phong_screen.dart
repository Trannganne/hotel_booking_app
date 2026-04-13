import 'package:flutter/material.dart';
import '../../core/widgets/room_card_widget.dart';

class QLPhongScreen extends StatefulWidget {
  const QLPhongScreen({Key? key}) : super(key: key);

  @override
  State<QLPhongScreen> createState() => _QLPhongScreenState();
}

class _QLPhongScreenState extends State<QLPhongScreen> {
  // Dữ liệu mẫu
  final List<Map<String, dynamic>> _rooms = [
    {'so_phong': 'P101', 'tang': 1, 'loai': 'Deluxe', 'trang_thai': 'TRỐNG'},
    {
      'so_phong': 'P102',
      'tang': 1,
      'loai': 'Suite',
      'trang_thai': 'ĐANG SỬ DỤNG',
    },
    {
      'so_phong': 'P201',
      'tang': 2,
      'loai': 'Standard',
      'trang_thai': 'BẢO TRÌ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0077FF),
        title: const Text(
          'Quản lý phòng',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mở form sửa Thông tin Khách sạn'),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.business, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách phòng',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Mở form thêm phòng
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm phòng'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  // GỌI WIDGET Ở ĐÂY
                  return RoomCardWidget(
                    room: room,
                    onEdit: () {
                      // TODO: Mở form sửa phòng
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bấm sửa phòng ${room['so_phong']}'),
                        ),
                      );
                    },
                    onLock: () {
                      // TODO: Hiện Dialog hỏi xác nhận Khóa phòng
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bấm khóa phòng ${room['so_phong']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
