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

  Future<void> updateBookingStatus(String bookingId, String bookingStatus) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await bookingService.updateBookingStatus(bookingId, bookingStatus);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateBookingTotalPrice(String bookingId, double additionalAmount) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await bookingService.updateBookingTotalPrice(bookingId, additionalAmount);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<List<BookingModel>> fetchBookings({String? roomTypeId}) async {
    try {
      final all = await bookingService.getAllBookings();
      final filtered = all.where((booking) {
        if (roomTypeId != null && roomTypeId.isNotEmpty && booking.roomTypeId != roomTypeId) {
          return false;
        }
        final status = (booking.bookingStatus ?? '').toString();
        // Treat cancelled / no_show as non-blocking
        switch (status) {
          case 'cancelled':
          case 'Hủy':
          case 'no_show':
          case 'Không nhận phòng':
            return false;
          default:
            return true;
        }
      }).toList();
      return filtered;
    } catch (e) {
      rethrow;
    }
  }
}
