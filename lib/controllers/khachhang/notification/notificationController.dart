import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/models/BaseModel/NotificationModel.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:hotel_booking_app/services/notification_service/thongbao_service.dart';

class NotificationController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  StreamSubscription<List<NotificationModel>>? _subscription;

  bool isLoading = false;
  String? errorMessage;
  List<NotificationModel> notifications = [];

  void startListening() {
    final userId = _authService.uid;
    if (userId == null) {
      errorMessage = 'Không tìm thấy thông tin người dùng.';
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _notificationService
        .userNotificationsStream(userId)
        .listen(
          (data) {
            notifications = data;
            isLoading = false;
            errorMessage = null;
            notifyListeners();
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
            notifyListeners();
          },
        );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
    } catch (e) {
      debugPrint('Lỗi đánh dấu thông báo đã đọc: $e');
    }
  }

  Future<void> markAllRead() async {
    final userId = _authService.uid;
    if (userId == null) return;
    try {
      await _notificationService.markAllAsRead(userId);
    } catch (e) {
      debugPrint('Lỗi đánh dấu tất cả thông báo đã đọc: $e');
    }
  }

  Future<void> sendBookingNotification(String bookingId) async {
    await _notificationService.notifyBookingSuccess(bookingId);
  }

  Future<void> sendPaymentNotification(String orderCode) async {
    await _notificationService.notifyPaymentSuccess(orderCode);
  }

  Future<void> sendCancelNotification(String bookingId) async {
    await _notificationService.notifyCancelSuccess(bookingId);
  }

  Future<void> sendConfirmNotification(String bookingId) async {
    await _notificationService.notifyConfirm(bookingId);
  }

  Future<void> sendCompleteNotification(String bookingId) async {
    await _notificationService.notifyComplete(bookingId);
  }

  Future<void> sendCheckInNotification(String bookingId) async {
    await _notificationService.notifyCheckIn(bookingId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
