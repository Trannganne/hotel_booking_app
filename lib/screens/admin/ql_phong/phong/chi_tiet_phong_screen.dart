import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/room/roomController.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:provider/provider.dart';

import 'chinh_sua_phong_screen.dart';

class ChiTietPhongScreen extends StatelessWidget {
  final RoomModel room;
  final String roomTypeName;

  const ChiTietPhongScreen({
    Key? key,
    required this.room,
    required this.roomTypeName,
  }) : super(key: key);

  String _statusText(RoomStatus status) {
    switch (status) {
      case RoomStatus.available:
        return 'TRỐNG';
      case RoomStatus.cleaning:
        return 'ĐANG DỌN';
      case RoomStatus.maintenance:
        return 'BẢO TRÌ';
      case RoomStatus.locked:
        return 'KHÓA';
    }
  }

  Color _statusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.available:
        return Colors.green;
      case RoomStatus.cleaning:
        return Colors.blue;
      case RoomStatus.maintenance:
        return Colors.orange;
      case RoomStatus.locked:
        return Colors.red;
    }
  }

  Future<void> _lockRoom(BuildContext context, bool permanent) async {
    if (room.id == null) return;

    final controller = context.read<RoomController>();

    if (permanent) {
      await controller.lockPermanent(room.id!);
    } else {
      await controller.lockTemporary(room.id!);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          permanent ? 'Đã khóa phòng vĩnh viễn' : 'Đã khóa tạm thời để bảo trì',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  Future<void> _unlockRoom(BuildContext context) async {
    if (room.id == null) return;

    await context.read<RoomController>().unlockRoom(room.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã mở khóa phòng')));

    Navigator.pop(context, true);
  }

  Future<void> _deleteRoom(BuildContext context) async {
    if (room.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa phòng'),
        content: Text('Bạn có chắc muốn xóa phòng ${room.roomNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await context.read<RoomController>().softDeleteRoom(room.id!);

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa phòng')));

    Navigator.pop(context, true);
  }

  Future<void> _openEditScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChinhSuaPhongScreen(room: room)),
    );

    if (!context.mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(room.status);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9),
      appBar: const CustomAppBar(title: 'Chi tiết phòng'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Phòng ${room.roomNumber}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _statusText(room.status),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 12),

                  _buildInfoRow('Loại phòng', roomTypeName),
                  _buildInfoRow('Tầng', room.floor.toString()),
                  _buildInfoRow('Mã loại phòng', room.roomTypeId),
                  _buildInfoRow(
                    'Trạng thái dữ liệu',
                    room.isDeleted ? 'Đã xóa mềm' : 'Đang hoạt động',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quản lý trạng thái phòng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  if (room.status == RoomStatus.maintenance ||
                      room.status == RoomStatus.locked)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _unlockRoom(context),
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Mở khóa phòng'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _lockRoom(context, false),
                          icon: const Icon(Icons.build),
                          label: const Text('Bảo trì'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _lockRoom(context, true),
                          icon: const Icon(Icons.lock),
                          label: const Text('Khóa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openEditScreen(context),
                          icon: const Icon(Icons.edit),
                          label: const Text('Chỉnh sửa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4DB6F5),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _deleteRoom(context),
                          icon: const Icon(Icons.delete),
                          label: const Text('Xóa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
