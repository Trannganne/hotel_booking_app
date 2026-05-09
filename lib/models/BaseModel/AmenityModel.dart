// Class Tiện ích
class Amenitymodel {
  String? id;
  String amenityName;
  String icon;

  Amenitymodel({this.id, required this.amenityName, required this.icon});

  Map<String, dynamic> toJson() => {"amenityName": amenityName, "icon": icon};

  factory Amenitymodel.fromJson(Map<String, dynamic> json, String id) {
    return Amenitymodel(
      id: id,
      amenityName: json["amenityName"],
      icon: json["icon"],
    );
  }
}
