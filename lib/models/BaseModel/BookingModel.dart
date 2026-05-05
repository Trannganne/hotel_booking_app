// models/dat_phong.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;

  // Liên kết ID
  final String userId;
  final String roomTypeId;
  final List<String>? roomIds;
  final String policyId;

  // Thời gian
  final DateTime checkIn;
  final DateTime checkout;

  // Số lượng phòng
  final int quantity; // cho phép đặt nhiều phòng cùng loại

  //Trạng thái
  final String
  bookingStatus; // pending/ confirmed/ checkin/ completed/ cancelled/ no_show(khách không đến)

  final DateTime? createdAt;

  BookingModel({
    this.id,
    required this.userId,
    required this.roomTypeId,
    this.roomIds,
    required this.policyId,
    required this.checkIn,
    required this.checkout,
    this.quantity = 1,

    this.bookingStatus = "pending",
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "roomTypeId": roomTypeId,
    "roomIds": roomIds ?? [],
    "policyId": policyId,
    "checkIn": Timestamp.fromDate(checkIn),
    "checkout": Timestamp.fromDate(checkout),
    //"totalNights": totalNights,
    "quantity": quantity,
    "bookingStatus": bookingStatus,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory BookingModel.fromJson(Map<String, dynamic> json, String id) {
    return BookingModel(
      id: id,
      // ID
      userId: json["userId"] ?? '',
      roomTypeId: json["roomTypeId"] ?? '',
      roomIds: List<String>.from(json["roomIds"] ?? []),
      policyId: json["policyId"] ?? '',

      // Time
      checkIn: (json["checkIn"] as Timestamp).toDate(),
      checkout: (json["checkout"] as Timestamp).toDate(),
      //totalNights: json["totalNights"] ?? 0,

      // Quantity
      quantity: json["quantity"] ?? 1,

      // Status
      bookingStatus: json["bookingStatus"] ?? "pending",

      // CreatedAt
      createdAt: json["createdAt"] != null
          ? (json["createdAt"] as Timestamp).toDate()
          : null,
    );
  }
}
