// models/BaseModel/RoomTypeModel.dart

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
    double parseDouble(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString().replaceAll(',', '')) ?? 0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return [];
    }

    return RoomTypeModel(
      id: id,
      roomTypeName:
          json["roomTypeName"]?.toString() ??
          json["name"]?.toString() ??
          json["typeName"]?.toString() ??
          "",
      pricePerNight: parseDouble(json["pricePerNight"]),
      area: parseDouble(json["area"]),
      bedType: json["bedType"]?.toString() ?? "",
      bedCount: parseInt(json["bedCount"]),
      maxOccupancy: parseInt(json["maxOccupancy"]),
      view: json["view"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      policyId: json["policyId"]?.toString() ?? "",
      amensIds: parseStringList(json["amensIds"]),
      imagesList: parseStringList(json["imagesList"]),
    );
  }
}
