import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';
import 'package:hotel_booking_app/services/roomType_service/roomType_Service.dart';

abstract class BookingService {
  Future<BookingModel> createBooking(CreateBookingRequest request);
  Future<List<BookingModel>> getAllBookings();
  Future<void> updateBookingStatus(String bookingId, String bookingStatus);
  Future<void> updateBookingTotalPrice(String bookingId, double additionalAmount);
}

class FirebaseBookingService implements BookingService {
  final db = FirestoreService();
  final RoomTypeService roomTypeService = RoomTypeService();

  CollectionReference<BookingModel> get _ref =>
      db.colWithConverter<BookingModel>(
        name: 'bookings',
        fromFirestore: (snap, _) =>
            BookingModel.fromJson(snap.data()!, snap.id),
        toFirestore: (b, _) => b.toJson(),
      );

  @override
  Future<BookingModel> createBooking(CreateBookingRequest request) async {
    //  Xử lý gán dữ liệu cho BookingModel
    try {
      // 1. Lấy roomType
      final roomTypeDoc = await roomTypeService.getByID(request.roomTypeId);

      if (roomTypeDoc == null) {
        throw Exception("RoomType không tồn tại");
      }

      final policyId = roomTypeDoc.policyId;

      // 2. Tạo booking
      final docRef = _ref.doc();

      final booking = BookingModel(
        id: docRef.id,
        userId: request.userId,
        roomTypeId: request.roomTypeId,
        roomIds: [],
        policyId: policyId, //  lấy từ roomType
        checkIn: request.checkIn,
        checkout: request.checkOut,
        quantity: request.quantity,
        bookingStatus: "pending",
      );

      await docRef.set(booking);

      return booking;
    } catch (e) {
      throw Exception("Create booking failed: $e");
    }
  }

  @override
  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await _ref.get();
    final bookings = snapshot.docs.map((e) => e.data()).toList();
    bookings.sort((a, b) {
      final aDate = a.createdAt ?? a.checkIn;
      final bDate = b.createdAt ?? b.checkIn;
      return bDate.compareTo(aDate);
    });
    return bookings;
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String bookingStatus) async {
    try {
      await _ref.doc(bookingId).update({
        'bookingStatus': bookingStatus,
      });
    } catch (e) {
      throw Exception('Update booking status failed: $e');
    }
  }

  @override
  Future<void> updateBookingTotalPrice(String bookingId, double additionalAmount) async {
    try {
      final doc = await _ref.doc(bookingId).get();
      final currentTotal = doc.data()?.totalPrice ?? 0;

      await _ref.doc(bookingId).update({
        'totalPrice': currentTotal + additionalAmount,
      });
    } catch (e) {
      throw Exception('Update booking total price failed: $e');
    }
  }
}
