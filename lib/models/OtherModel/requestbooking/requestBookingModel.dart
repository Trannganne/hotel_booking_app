class CreateBookingRequest {
  final String userId;
  final String roomTypeId;

  final DateTime checkIn;
  final DateTime checkOut;

  final int quantity;
  final int guests;
  final double totalPrice;
  final bool bookingForSelf;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String specialRequest;

  CreateBookingRequest({
    required this.userId,
    required this.roomTypeId,
    required this.checkIn,
    required this.checkOut,
    required this.quantity,
    this.guests = 1,
    this.totalPrice = 0,
    this.bookingForSelf = true,
    this.contactName = '',
    this.contactEmail = '',
    this.contactPhone = '',
    this.specialRequest = '',
  });
}
