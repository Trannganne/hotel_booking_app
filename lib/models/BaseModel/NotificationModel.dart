// models/thong_bao.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String userId;
  String? bookingId;
  String title;
  String content;
  String type;
  bool isRead;
  DateTime? createdAt;

  NotificationModel({
    this.id,
    required this.userId,
    this.bookingId,
    required this.title,
    required this.content,
    required this.type,
    this.isRead = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "bookingId": bookingId,
    "title": title,
    "content": content,
    "type": type,
    "isRead": isRead,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      userId: json["userId"],
      bookingId: json["bookingId"],
      title: json["title"],
      content: json["content"],
      type: json["type"],
      isRead: json["isRead"] ?? false,
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
