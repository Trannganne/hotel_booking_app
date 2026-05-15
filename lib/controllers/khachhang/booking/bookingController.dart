import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';
import 'package:hotel_booking_app/services/payment_service/thanhtoan_service.dart';
import 'package:hotel_booking_app/services/roomType_service/roomType_Service.dart';

class BookingController extends ChangeNotifier {
  final BookingService bookingService = FirebaseBookingService();
  final RoomTypeService roomTypeService = RoomTypeService();
  final PaymentService paymentService = PaymentService();

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

  Future<void> updateBookingStatus(
    String bookingId,
    String bookingStatus,
  ) async {
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

  Future<void> updateBookingTotalPrice(
    String bookingId,
    double additionalAmount,
  ) async {
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
        if (roomTypeId != null &&
            roomTypeId.isNotEmpty &&
            booking.roomTypeId != roomTypeId) {
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

  // Lấy loại phòng tương ứng
  Future<RoomTypeModel?> getRoomTypeForBooking(BookingModel booking) async {
    try {
      return await roomTypeService.getByID(booking.roomTypeId);
    } catch (e) {
      // Log lỗi nếu cần
      print("Lỗi lấy loại phòng cho booking: ${booking.id}: $e");
      notifyListeners();
      return null;
    }
  }

  // Lấy payment tương ứng
  Future<PaymentModel?> getPaymentForBooking(BookingModel booking) async {
    try {
      return await paymentService.getByBookingID(booking.id!);
    } catch (e) {
      // Log lỗi nếu cần
      print("Lỗi lấy payment cho booking: ${booking.id}: $e");
      notifyListeners();
      return null;
    }
  }
}
