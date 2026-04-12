/// Model trung gian mô tả tập hành động hợp lệ của một booking.
///
/// Screen chỉ đọc model này để quyết định hiển thị nút nào.
/// Như vậy rule nghiệp vụ không bị viết trực tiếp trong UI.
class BookingActionState {
  final bool canCancel;
  final bool canChangeRoom;
  final bool canReview;

  const BookingActionState({
    required this.canCancel,
    required this.canChangeRoom,
    required this.canReview,
  });
}
