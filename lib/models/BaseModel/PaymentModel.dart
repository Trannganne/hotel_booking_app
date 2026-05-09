import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String? id;

  String bookingId; // liên kết booking
  String orderCode; // mã đơn để đối soát (QR dùng cái này)
  double totalPrice;

  String paymentMethod; // TRANSFER, CASH
  String status; // PENDING, PAID, FAILED, CANCELLED

  DateTime? createdAt;
  DateTime? paidAt;

  // QR / bank transfer info
  String? transferContent;
  String? transactionId; // từ ngân hàng / cổng thanh toán

  PaymentModel({
    this.id,
    required this.bookingId,
    required this.orderCode,
    required this.totalPrice,
    required this.paymentMethod,
    this.status = "PENDING",
    this.createdAt,
    this.paidAt,
    this.transferContent,
    this.transactionId,
  });

  Map<String, dynamic> toJson() => {
    "bookingId": bookingId,
    "orderCode": orderCode,
    "totalPrice": totalPrice,
    "paymentMethod": paymentMethod,
    "status": status,
    "createdAt": createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
    "paidAt": paidAt != null ? Timestamp.fromDate(paidAt!) : null,
    "transferContent": transferContent,
    "transactionId": transactionId,
  };

  factory PaymentModel.fromJson(Map<String, dynamic> json, String id) {
    return PaymentModel(
      id: id,
      bookingId: json["bookingId"],
      orderCode: json["orderCode"],
      totalPrice: (json["totalPrice"] as num).toDouble(),
      paymentMethod: json["paymentMethod"],
      status: json["status"],
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
      paidAt: (json["paidAt"] as Timestamp?)?.toDate(),
      transferContent: json["transferContent"],
      transactionId: json["transactionId"],
    );
  }
}
