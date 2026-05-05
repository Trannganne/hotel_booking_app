import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  String? id;
  String hotelName;
  String address;
  String city;
  String description;
  double? averageRating;
  String image;
  DateTime? createdAt;

  HotelModel({
    this.id,
    required this.hotelName,
    required this.address,
    required this.city,
    required this.description,
    this.averageRating,
    required this.image,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "hotelName": hotelName,
    "address": address,
    "city": city,
    "description": description,
    "averageRating": averageRating,
    "image": image,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory HotelModel.fromJson(Map<String, dynamic> json, String id) {
    return HotelModel(
      id: id,
      hotelName: json["hotelName"],
      address: json["address"],
      city: json["city"],
      description: json["description"],
      averageRating: (json["averageRating"] as num?)?.toDouble(),
      image: json["image"],
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
