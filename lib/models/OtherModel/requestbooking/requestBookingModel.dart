class CreateBookingRequest {
  final String userId;
  final String roomTypeId;

  final DateTime checkIn;
  final DateTime checkOut;

  final int quantity;

  CreateBookingRequest({
    required this.userId,
    required this.roomTypeId,
    required this.checkIn,
    required this.checkOut,
    required this.quantity,
  });
}
