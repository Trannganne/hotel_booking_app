import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';

class BookingController extends ChangeNotifier {
  final BookingService bookingService = FirebaseBookingService();

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

  List<BookingModel> filter({
    required List<BookingModel> source,
    String keyword = "",
    String? status,
    DateTime? selectedDate,
  }) {
    return source.where((b) {
      final matchKeyword =
          keyword.isEmpty ||
          b.id?.toLowerCase().contains(keyword.toLowerCase()) == true;

      final matchStatus =
          status == null || status == "all" || b.bookingStatus == status;

      final matchDate =
          selectedDate == null ||
          (b.checkIn.year == selectedDate.year &&
              b.checkIn.month == selectedDate.month &&
              b.checkIn.day == selectedDate.day);

      return matchKeyword && matchStatus && matchDate;
    }).toList();
  }
}
