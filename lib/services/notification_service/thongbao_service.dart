import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hotel_booking_app/models/BaseModel/NotificationModel.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _firestoreService = FirestoreService();
  static final AuthService _authService = AuthService();

  //  Converted
  CollectionReference<NotificationModel> get _ref =>
      _firestoreService.colWithConverter<NotificationModel>(
        name: 'notifications',
        fromFirestore: (snap, _) =>
            NotificationModel.fromJson(snap.data()!, snap.id),
        toFirestore: (r, _) => r.toJson(),
      );

  // Khởi tạo thông báo
  static Future<void> init() async {
    // 1. Khởi tạo timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Asia/Ho_Chi_Minh'),
    ); // Đặt múi giờ Việt Nam

    // 2. Android settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    // 3. Init plugin
    await _notificationsPlugin.initialize(settings);

    // 4. Xin quyền Notification
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

  static int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
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

  // ============= FIRESTORE ==============

  Future<void> saveNotification(NotificationModel notification) async {
    final docRef = _ref.doc();
    notification.id = docRef.id;
    await docRef.set(notification);
  }

  Stream<List<NotificationModel>> userNotificationsStream(String userId) {
    return _ref
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    if (notificationId.isEmpty) return;
    await _ref.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final query = await _ref
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestoreService.db.batch();
    for (final doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    if (query.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  Future<void> _notifyAndSave({
    required String title,
    required String body,
    required String type,
    String? bookingId,
    String? payload,
  }) async {
    final notificationId = _generateNotificationId();
    await showNotification(
      id: notificationId,
      title: title,
      body: body,
      payload: payload,
    );

    final userId = _authService.uid;
    if (userId == null) return;

    final notification = NotificationModel(
      userId: userId,
      bookingId: bookingId,
      title: title,
      content: body,
      type: type,
      isRead: false,
    );

    await saveNotification(notification);
  }

  // Khhi có sự kiện đặt phòng thành công, gửi thông báo đến khách hàng
  Future<void> notifyBookingSuccess(String maDon) async {
    await _notifyAndSave(
      title: 'Đặt phòng thành công',
      body: 'Mã đơn $maDon đã được ghi nhận. Chờ khách sạn xác nhận nhé!',
      type: 'booking',
      bookingId: maDon,
      payload: 'booking_details_$maDon',
    );
  }

  Future<void> notifyPaymentSuccess(String maDon) async {
    await _notifyAndSave(
      title: 'Thanh toán thành công',
      body: 'Mã đơn $maDon đã được thanh toán. Cảm ơn bạn đã tin tưởng!',
      type: 'payment',
      bookingId: maDon,
      payload: 'payment_details_$maDon',
    );
  }

  Future<void> notifyCancelSuccess(String maDon) async {
    await _notifyAndSave(
      title: 'Đã hủy đặt phòng',
      body: 'Đơn đặt phòng $maDon đã được hủy thành công.',
      type: 'cancel',
      bookingId: maDon,
    );
  }

  Future<void> notifyCheckIn(String maDon) async {
    await _notifyAndSave(
      title: 'Nhận phòng thành công',
      body: 'Chào mừng bạn! Bạn đã nhận phòng cho đơn $maDon.',
      type: 'checkin',
      bookingId: maDon,
    );
  }

  Future<void> notifyComplete(String maDon) async {
    await _notifyAndSave(
      title: 'Hoàn tất kỳ nghỉ',
      body: 'Cảm ơn bạn đã ở lại! Đơn $maDon đã hoàn tất. Hẹn gặp lại!',
      type: 'complete',
      bookingId: maDon,
    );
  }

  // Khi admin xác nhận đơn đặt phòng, gửi thông báo đến khách hàng
  Future<void> notifyConfirm(String maDon) async {
    await _notifyAndSave(
      title: 'Xác nhận đặt phòng',
      body:
          'Đơn đặt phòng $maDon đã được xác nhận.Hãy đến check-in đúng giờ nhé!',
      type: 'confirm',
      bookingId: maDon,
    );
  }
}
