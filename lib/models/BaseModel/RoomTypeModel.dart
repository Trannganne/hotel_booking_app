// models/loai_phong.dart
class RoomTypeModel {
  String? id;
  String roomTypeName;
  double pricePerNight;
  double area;
  String bedType;
  int bedCount;
  int maxOccupancy;
  String view;
  String description;
  String policyId;
  List<String> amensIds;
  List<String> imagesList;

  RoomTypeModel({
    this.id,
    required this.roomTypeName,
    required this.pricePerNight,
    required this.area,
    required this.bedType,
    required this.bedCount,
    required this.maxOccupancy,
    required this.view,
    required this.description,
    required this.policyId,
    this.amensIds = const [],
    this.imagesList = const [],
  });

  Map<String, dynamic> toJson() => {
    "roomTypeName": roomTypeName,
    "pricePerNight": pricePerNight,
    "area": area,
    "bedType": bedType,
    "bedCount": bedCount,
    "maxOccupancy": maxOccupancy,
    "view": view,
    "description": description,
    "policyId": policyId,
    "amensIds": amensIds,
    "imagesList": imagesList,
  };

  factory RoomTypeModel.fromJson(Map<String, dynamic> json, String id) {
    return RoomTypeModel(
      id: id,
      roomTypeName: json["roomTypeName"] ?? "",
      pricePerNight: (json["pricePerNight"] as num).toDouble(),
      area: (json["area"] as num).toDouble(),
      bedType: json["bedType"] ?? "",
      bedCount: json["bedCount"] ?? 0,
      maxOccupancy: json["maxOccupancy"] ?? 0,
      view: json["view"] ?? "",
      description: json["description"] ?? "",
      policyId: json["policyId"] ?? "",
      amensIds: List<String>.from(json["amensIds"] ?? []),
      imagesList: List<String>.from(json["imagesList"] ?? []),
    );
  }
}
