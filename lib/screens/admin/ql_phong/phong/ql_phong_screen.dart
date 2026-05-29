import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/room/roomController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:provider/provider.dart';

import 'them_phong_screen.dart';
import 'chinh_sua_phong_screen.dart';

class QLPhongScreen extends StatefulWidget {
  const QLPhongScreen({Key? key}) : super(key: key);

  @override
  State<QLPhongScreen> createState() => _QLPhongScreenState();
}

class _QLPhongScreenState extends State<QLPhongScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RoomTypeController>().loadRooms();
      await context.read<RoomController>().loadRooms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _roomTypeName(List<RoomTypeModel> roomTypes, String roomTypeId) {
    try {
      return roomTypes.firstWhere((type) => type.id == roomTypeId).roomTypeName;
    } catch (_) {
      return 'Chưa rõ loại phòng';
    }
  }

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

  Future<void> _openLockDialog(RoomModel room) async {
    if (room.id == null) return;

    final controller = context.read<RoomController>();

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Khóa phòng ${room.roomNumber}'),
          content: const Text('Bạn muốn khóa phòng theo hình thức nào?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await controller.lockTemporary(room.id!);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã khóa tạm thời để bảo trì')),
                );
              },
              child: const Text('Khóa tạm'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await controller.lockPermanent(room.id!);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã khóa phòng vĩnh viễn')),
                );
              },
              child: const Text(
                'Khóa vĩnh viễn',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _unlockRoom(RoomModel room) async {
    if (room.id == null) return;

    await context.read<RoomController>().unlockRoom(room.id!);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã mở khóa phòng')));
  }

  Future<void> _deleteRoom(RoomModel room) async {
    if (room.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Xóa phòng'),
          content: Text(
            'Bạn có chắc muốn xóa phòng ${room.roomNumber} không?\n\n'
            'Phòng sẽ bị ẩn khỏi danh sách nhưng dữ liệu vẫn còn trong Firebase.',
          ),
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
        );
      },
    );

    if (confirm != true) return;

    final success = await context.read<RoomController>().softDeleteRoom(
      room.id!,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa phòng ${room.roomNumber}')),
      );
    } else {
      final error = context.read<RoomController>().errorMessage;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Xóa phòng thất bại')));
    }
  }

  Future<void> _goToAddRoom() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ThemPhongScreen()),
    );

    if (!mounted) return;
    await context.read<RoomController>().loadRooms();
  }

  Future<void> _goToEditRoom(RoomModel room) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChinhSuaPhongScreen(room: room)),
    );

    if (!mounted) return;
    await context.read<RoomController>().loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    final roomController = context.watch<RoomController>();
    final roomTypeController = context.watch<RoomTypeController>();

    final rooms = roomController.filteredRooms;
    final roomTypes = roomTypeController.rooms;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9),
      appBar: const CustomAppBar(
        title: 'Danh sách phòng',
        showBackButton: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddRoom,
        backgroundColor: const Color(0xFF75C8F2),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: roomController.search,
              decoration: InputDecoration(
                hintText: 'Tìm số phòng, tầng, trạng thái...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          if (roomController.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                roomController.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          Expanded(
            child: roomController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : rooms.isEmpty
                ? const Center(child: Text('Chưa có phòng nào'))
                : RefreshIndicator(
                    onRefresh: roomController.loadRooms,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];

                        return _buildRoomCard(
                          room: room,
                          roomTypeName: _roomTypeName(
                            roomTypes,
                            room.roomTypeId,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard({
    required RoomModel room,
    required String roomTypeName,
  }) {
    final color = _statusColor(room.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Phòng ${room.roomNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _statusText(room.status),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text('Loại phòng: $roomTypeName'),
            const SizedBox(height: 4),
            Text('Tầng: ${room.floor}'),

            const SizedBox(height: 12),
            const Divider(),

            _buildActionRow(room),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(RoomModel room) {
    final actions = <Widget>[];

    if (room.status == RoomStatus.locked ||
        room.status == RoomStatus.maintenance) {
      actions.add(
        _buildActionButton(
          icon: Icons.lock_open,
          label: 'Mở khóa',
          onPressed: () => _unlockRoom(room),
        ),
      );
    }

    actions.addAll([
      _buildActionButton(
        icon: Icons.edit,
        label: 'Sửa',
        onPressed: () => _goToEditRoom(room),
      ),
      _buildActionButton(
        icon: Icons.lock,
        label: 'Khóa',
        onPressed: () => _openLockDialog(room),
      ),
      _buildActionButton(
        icon: Icons.delete,
        label: 'Xóa',
        color: Colors.red,
        onPressed: () => _deleteRoom(room),
      ),
    ]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions.map((button) => Expanded(child: button)).toList(),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color color = const Color(0xFF7E57C2),
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon, color: color, size: 17),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
