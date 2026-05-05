// models/phong.dart
class RoomModel {
  String? id;
  String roomTypeId;
  String roomNumber;
  int floor;
  String status;

  RoomModel({
    this.id,
    required this.roomTypeId,
    required this.roomNumber,
    required this.floor,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    "roomTypeId": roomTypeId,
    "roomNumber": roomNumber,
    "floor": floor,
    "status": status, // AVAILABLE, BOOKED, CLEANING, MAINTENANCE
  };

  factory RoomModel.fromJson(Map<String, dynamic> json, String id) {
    return RoomModel(
      id: id,
      roomTypeId: json["roomTypeId"] ?? "",
      roomNumber: json["roomNumber"] ?? "",
      floor: json["floor"] ?? 0,
      status: json["status"] ?? "AVAILABLE",
    );
  }
}
