/// Trạng thái đơn đặt phòng của khách hàng.
enum BookingStatus {
  pending,
  confirmed,
  checkedIn,
  completed,
  cancelled,
}

/// Extension gom các rule nghiệp vụ theo trạng thái.
extension BookingStatusX on BookingStatus {
  /// Nhãn tiếng Việt để hiển thị ngoài giao diện.
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Chờ xác nhận';
      case BookingStatus.confirmed:
        return 'Đã xác nhận';
      case BookingStatus.checkedIn:
        return 'Đã nhận phòng';
      case BookingStatus.completed:
        return 'Hoàn tất';
      case BookingStatus.cancelled:
        return 'Đã hủy';
    }
  }

  /// Đơn chưa nhận phòng thì mới được hủy.
  bool get canCancel {
    return this == BookingStatus.pending || this == BookingStatus.confirmed;
  }

  /// Đơn chưa nhận phòng thì mới được đổi phòng.
  bool get canChangeRoom {
    return this == BookingStatus.pending || this == BookingStatus.confirmed;
  }

  /// Đơn hoàn tất mới được đánh giá.
  bool get canReview {
    return this == BookingStatus.completed;
  }
}
