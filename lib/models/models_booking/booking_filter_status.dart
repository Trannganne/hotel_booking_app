import 'booking_status.dart';

/// Bộ lọc trạng thái dùng cho màn lịch đặt phòng.
enum BookingFilterStatus {
  all,
  pending,
  confirmed,
  checkedIn,
  completed,
  cancelled,
}

extension BookingFilterStatusX on BookingFilterStatus {
  /// Nhãn hiển thị trên dropdown.
  String get label {
    switch (this) {
      case BookingFilterStatus.all:
        return 'Tất cả';
      case BookingFilterStatus.pending:
        return 'Chờ xác nhận';
      case BookingFilterStatus.confirmed:
        return 'Đã xác nhận';
      case BookingFilterStatus.checkedIn:
        return 'Đã nhận phòng';
      case BookingFilterStatus.completed:
        return 'Hoàn tất';
      case BookingFilterStatus.cancelled:
        return 'Đã hủy';
    }
  }

  /// Quy đổi bộ lọc sang trạng thái booking.
  BookingStatus? get valueOrNull {
    switch (this) {
      case BookingFilterStatus.all:
        return null;
      case BookingFilterStatus.pending:
        return BookingStatus.pending;
      case BookingFilterStatus.confirmed:
        return BookingStatus.confirmed;
      case BookingFilterStatus.checkedIn:
        return BookingStatus.checkedIn;
      case BookingFilterStatus.completed:
        return BookingStatus.completed;
      case BookingFilterStatus.cancelled:
        return BookingStatus.cancelled;
    }
  }
}
