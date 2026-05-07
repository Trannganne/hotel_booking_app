import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày tháng

enum NotificationType { booking, cancel, checkIn, complete, system }

class ThongBao {
  final int id;
  final String title;
  final String body;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  ThongBao({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dữ liệu giả lập (Sau này lấy từ Database/Service)
  List<ThongBao> notifications = [
    ThongBao(
      id: 1,
      title: "Đặt phòng thành công",
      body:
          "Đơn hàng #BK102 của bạn đã được xác nhận. Hẹn gặp bạn tại khách sạn!",
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.booking,
    ),
    ThongBao(
      id: 2,
      title: "Lời mời nhận phòng",
      body: "Đã đến giờ nhận phòng cho mã đơn #BK098. Lễ tân đang đợi bạn.",
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.checkIn,
    ),
    ThongBao(
      id: 3,
      title: "Xác nhận hủy phòng",
      body:
          "Bạn đã hủy thành công đơn #BK088. Tiền hoàn lại sẽ được xử lý trong 3-5 ngày.",
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.cancel,
      isRead: true,
    ),
  ];

  // Hàm trả về màu sắc và icon dựa trên loại thông báo
  Map<String, dynamic> _getStyle(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return {'color': Colors.green, 'icon': Icons.bookmark_added};
      case NotificationType.cancel:
        return {'color': Colors.red, 'icon': Icons.cancel};
      case NotificationType.checkIn:
        return {'color': Colors.blue, 'icon': Icons.vpn_key};
      case NotificationType.complete:
        return {'color': Colors.orange, 'icon': Icons.stars};
      default:
        return {'color': Colors.grey, 'icon': Icons.notifications};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông báo của tôi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF0077FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => setState(() {
              for (var n in notifications) {
                n.isRead = true;
              }
            }),
            tooltip: "Đánh dấu tất cả là đã đọc",
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final style = _getStyle(item.type);

                return Container(
                  color: item.isRead
                      ? Colors.transparent
                      : Colors.blue.withOpacity(0.05),
                  child: ListTile(
                    onTap: () => setState(() => item.isRead = true),
                    leading: CircleAvatar(
                      backgroundColor: style['color'].withOpacity(0.1),
                      child: Icon(style['icon'], color: style['color']),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: item.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm - dd/MM/yyyy').format(item.time),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: item.isRead
                        ? null
                        : const CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.blue,
                          ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "Không có thông báo nào",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
