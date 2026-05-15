import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteModel {
  String? id;
  String userId;
  String roomTypeId;
  DateTime? createdAt;

  FavouriteModel({
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

  factory FavouriteModel.fromJson(Map<String, dynamic> json, String id) {
    return FavouriteModel(
      id: id,
      userId: json["userId"] ?? '',
      roomTypeId: json["roomTypeId"],
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
