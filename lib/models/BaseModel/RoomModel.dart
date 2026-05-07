// models/phong.dart

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

  Map<String, dynamic> toJson() => {
    "roomTypeId": roomTypeId,
    "roomNumber": roomNumber,
    "floor": floor,
    "status": status.name,
    "isDeleted": isDeleted,
    "createdAt": createdAt,
  };

  factory RoomModel.fromJson(Map<String, dynamic> json, String id) {
    return RoomModel(
      id: id,
      roomTypeId: json["roomTypeId"] ?? "",
      roomNumber: json["roomNumber"] ?? "",
      floor: json["floor"] ?? 0,
      status: RoomStatus.values.firstWhere(
        (e) => e.name == (json["status"] ?? "available"),
      ),
      isDeleted: json["isDeleted"] ?? false,
    );
  }
}
