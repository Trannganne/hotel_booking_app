import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';

class BookingPreviewModel {
  final CreateBookingRequest bookingRequest;
  final RoomTypeModel roomType;
  final UserModel user;
  final PolicyModel policy;

  const BookingPreviewModel({
    required this.bookingRequest,
    required this.roomType,
    required this.user,
    required this.policy,
  });

  // Lấy thông tin hiển thị của khách hàng thông qua UserModel
  String get customerName => user.fullName;
  String get customerPhone => user.phoneNumber;
  String get customerEmail => user.email;
  String get customerAvatar =>
      user.avatar ??
      "https://i.pinimg.com/736x/bc/43/98/bc439871417621836a0eeea768d60944.jpg";

  // Tính số đêm dựa trên ngày check-in và check-out trong bookingRequest
  int get totalNights {
    final difference = bookingRequest.checkOut
        .difference(bookingRequest.checkIn)
        .inDays;
    return difference <= 0 ? 1 : difference; // Tối thiểu là 1 đêm
  }

  // Tính tổng tiền phòng thô
  double get totalRoomPrice {
    return (roomType.pricePerNight ?? 0) *
        totalNights *
        bookingRequest.quantity;
  }
}
