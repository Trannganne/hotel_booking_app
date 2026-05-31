import 'package:cloud_firestore/cloud_firestore.dart';

enum RoomStatus { available, cleaning, maintenance, locked }

class RoomModel {
  String? id;
  String roomTypeId;
  String roomNumber;
  int floor;
  RoomStatus status;
  bool isDeleted;
  DateTime? createdAt;

  RoomModel({
    this.id,
    required this.roomTypeId,
    required this.roomNumber,
    required this.floor,
    required this.status,
    this.isDeleted = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "roomTypeId": roomTypeId,
      "roomNumber": roomNumber,
      "floor": floor,
      "status": status.name,
      "isDeleted": isDeleted,
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory RoomModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime? parseCreatedAt(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    RoomStatus parseStatus(dynamic value) {
      final text = value?.toString() ?? "available";

      return RoomStatus.values.firstWhere(
        (e) => e.name == text,
        orElse: () => RoomStatus.available,
      );
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return RoomModel(
      id: id,
      roomTypeId: json["roomTypeId"]?.toString() ?? "",
      roomNumber: json["roomNumber"]?.toString() ?? "",
      floor: parseInt(json["floor"]),
      status: parseStatus(json["status"]),
      isDeleted: json["isDeleted"] == true,
      createdAt: parseCreatedAt(json["createdAt"]),
    );
  }
}
