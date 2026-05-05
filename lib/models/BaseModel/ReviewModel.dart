// models/danh_gia.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String bookingId;
  String userId;
  int rating;
  String content;
  DateTime? createdAt;
  List<String>? images; // Thêm trường để lưu danh sách hình ảnh đánh giá

  String? adminReply; // Để lưu nội dung Admin trả lời
  String? userName;
  String? userAvatar;

  ReviewModel({
    this.id,
    required this.bookingId,
    required this.userId,
    required this.rating,
    required this.content,
    this.images,
    this.createdAt,
    this.adminReply,
    this.userName,
    this.userAvatar,
  });

  //Convert sang JSON để lưu Firestore
  Map<String, dynamic> toJson() {
    return {
      "bookingId": bookingId,
      "userId": userId,
      "rating": rating,
      "content": content,
      "images": images ?? [],
      "createdAt": FieldValue.serverTimestamp(),
      "adminReply": adminReply,
      "userName": userName,
      "userAvatar": userAvatar,
    };
  }

  // Convert từ Firestore về object
  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    return ReviewModel(
      id: id,
      bookingId: json["bookingId"],
      userId: json["userId"],
      rating: json["rating"],
      content: json["content"],
      images: List<String>.from(json["images"] ?? []),
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
      adminReply: json["adminReply"],
      userName: json["userName"],
      userAvatar: json["userAvatar"],
    );
  }
}
