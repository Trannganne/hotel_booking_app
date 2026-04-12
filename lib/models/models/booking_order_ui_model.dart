import 'booking_status.dart';

/// Model UI đại diện cho một đơn đặt phòng của khách hàng.
class BookingOrderUiModel {
  final String id;
  final String bookingCode;
  final String hotelName;
  final String roomName;
  final String roomCode;
  final String? hotelImage;
  final BookingStatus status;
  final String checkInDate;
  final String checkOutDate;
  final String stayText;
  final String nightlyPriceText;
  final String totalPriceText;
  final String totalActualText;
  final String roomInfoText;
  final List<String> amenities;
  final List<String> policies;
  final int adults;

  const BookingOrderUiModel({
    required this.id,
    required this.bookingCode,
    required this.hotelName,
    required this.roomName,
    required this.roomCode,
    required this.hotelImage,
    required this.status,
    required this.checkInDate,
    required this.checkOutDate,
    required this.stayText,
    required this.nightlyPriceText,
    required this.totalPriceText,
    required this.totalActualText,
    required this.roomInfoText,
    required this.amenities,
    required this.policies,
    required this.adults,
  });
}
