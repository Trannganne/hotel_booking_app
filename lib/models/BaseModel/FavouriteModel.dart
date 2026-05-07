import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  String? id;
  String userId;
  String roomTypeId;
  DateTime? createdAt;

  FavoriteModel({
    this.id,
    required this.userId,
    required this.roomTypeId,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "roomTypeId": roomTypeId,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory FavoriteModel.fromJson(Map<String, dynamic> json, String id) {
    return FavoriteModel(
      id: id,
      userId: json["userId"] ?? '',
      roomTypeId: json["roomTypeId"],
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
