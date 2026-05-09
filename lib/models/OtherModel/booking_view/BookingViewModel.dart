import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceDetailsModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceModel.dart';

class BookingViewModel {
  final BookingModel booking;
  final RoomModel? room;
  final RoomTypeModel roomType;
  final PaymentModel? payment;
  final List<Amenitymodel> amenities;
  final List<ServiceDetailsModel>? serviceDetails;
  final List<ServiceModel>? services;

  // Hiển thị giá
  final int nights;
  final double roomFee;
  final double serviceFee;
  final double totalPrice;

  BookingViewModel({
    required this.booking,
    this.room,
    required this.roomType,
    this.payment,
    required this.amenities,
    this.serviceDetails,
    this.services,
    required this.nights,
    required this.roomFee,
    required this.serviceFee,
    required this.totalPrice,
  });
}
