/// Enum trạng thái đặt phòng.
///
/// File này chỉ giữ dữ liệu trạng thái cơ bản.
/// Các rule nghiệp vụ như được hủy / được đổi phòng / được đánh giá
/// sẽ được xử lý trong service để đúng với cấu trúc README.
enum BookingStatus {
  pending,
  confirmed,
  checkedIn,
  completed,
  cancelled,
}

/// Extension trả về nhãn hiển thị cho UI.
extension BookingStatusLabelX on BookingStatus {
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
}
