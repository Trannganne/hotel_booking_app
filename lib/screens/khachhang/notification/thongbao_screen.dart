import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/controllers/khachhang/notification/notificationController.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày tháng
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationController>().startListening();
    });
  }

  Map<String, dynamic> _getStyle(String type) {
    switch (type) {
      case 'booking':
        return {'color': Colors.green, 'icon': Icons.bookmark_added};
      case 'payment':
        return {'color': Colors.purple, 'icon': Icons.payment};
      case 'cancel':
        return {'color': Colors.red, 'icon': Icons.cancel};
      case 'checkin':
        return {'color': Colors.blue, 'icon': Icons.vpn_key};
      case 'complete':
        return {'color': Colors.orange, 'icon': Icons.stars};
      default:
        return {'color': Colors.grey, 'icon': Icons.notifications};
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationController>();
    final notifications = controller.notifications;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'THÔNG BÁO CỦA TÔI',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            color: Colors.white,
            onPressed: controller.markAllRead,
            tooltip: 'Đánh dấu tất cả là đã đọc',
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
          ? Center(
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final style = _getStyle(item.type);
                final time = item.createdAt ?? DateTime.now();

                return Container(
                  color: item.isRead
                      ? Colors.transparent
                      : Colors.blue.withValues(alpha: 0.05),
                  child: ListTile(
                    onTap: () {
                      if (!item.isRead && item.id != null) {
                        context.read<NotificationController>().markAsRead(
                          item.id!,
                        );
                      }
                    },
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
                          item.content,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm - dd/MM/yyyy').format(time),
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
            'Không có thông báo nào',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
