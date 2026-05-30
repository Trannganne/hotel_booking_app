/// Gom các quyền thao tác của đơn đặt để screen chỉ cần đọc và hiển thị.
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
