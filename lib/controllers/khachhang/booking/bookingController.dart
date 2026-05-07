import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';

class BookingController extends ChangeNotifier {
  final BookingService bookingService;
  BookingController(this.bookingService);

  bool isLoading = false;
  String? errorMessage;
  BookingModel? lastBooking;

  Future<void> createBooking(CreateBookingRequest request) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final booking = await bookingService.createBooking(
        request,
      ); // gọi từ booking_service
      lastBooking = booking;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
