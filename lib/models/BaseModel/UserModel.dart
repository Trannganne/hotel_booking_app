// models/tai_khoan.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id; // doc.id(uid)
  String fullName;
  String email;
  String phoneNumber;
  String? avatar;
  String role;
  DateTime? createdAt;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatar,
    this.role = "CUSTOMER",
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "avatar": (avatar == null || avatar!.isEmpty)
          ? "https://i.pinimg.com/736x/bc/43/98/bc439871417621836a0eeea768d60944.jpg"
          : avatar,
      "role": role,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      avatar: json["avatar"],
      role: json["role"] ?? "CUSTOMER",
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
