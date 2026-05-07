import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Khởi tạo thông báo
  static Future<void> init() async {
    // 1. Khởi tạo timezone
    tz.initializeTimeZones(); // Khởi tạo múi giờ cho thông báo lên lịch
    // Đặt múi giờ mặc định cho ứng dụng (timezone Việt Nam)
    tz.setLocalLocation(
      tz.getLocation('Asia/Ho_Chi_Minh'),
    ); // Đặt múi giờ Việt Nam

    // 2. Android settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    // 3. Init plugin
    await _notificationsPlugin.initialize(settings);

    //  4. Xin quyền Notification
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Cấu hình chi tiết cho Android (Channel)
  static AndroidNotificationDetails _createAndroidDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  // Hàm gửi thông báo ngay lập tức
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final details = _createAndroidDetails(
      channelId: 'hotel_booking_channel',
      channelName: 'Booking Notifications',
      channelDescription: 'Thông báo trạng thái đặt phòng khách sạn',
    );
    await _notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(android: details),
      payload: payload,
    );
  }
}

class BookingNotificationHelper {
  // 1. Đặt phòng thành công
  static void notifyBookingSuccess(String maDon) {
    NotificationService.showNotification(
      id: 1,
      title: "🏨 Đặt phòng thành công",
      body: "Mã đơn $maDon đã được ghi nhận. Chờ khách sạn xác nhận nhé!",
      payload: "booking_details_$maDon",
    );
  }

  // 2. Hủy phòng
  static void notifyCancelSuccess(String maDon) {
    NotificationService.showNotification(
      id: 2,
      title: "⚠️ Đã hủy đặt phòng",
      body: "Đơn đặt phòng $maDon đã được hủy thành công.",
    );
  }

  // 3. Nhận phòng (Check-in)
  static void notifyCheckIn(String maDon) {
    NotificationService.showNotification(
      id: 3,
      title: "🔑 Nhận phòng thành công",
      body: "Chào mừng bạn! Bạn đã nhận phòng cho đơn $maDon.",
    );
  }

  // 4. Hoàn tất (Check-out)
  static void notifyComplete(String maDon) {
    NotificationService.showNotification(
      id: 4,
      title: "Hoàn tất kỳ nghỉ",
      body: "Cảm ơn bạn đã ở lại! Đơn $maDon đã hoàn tất. Hẹn gặp lại!",
    );
  }
}
