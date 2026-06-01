import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  String? id;
  String hotelName;
  String address;
  String city;
  String description;
  String image;
  DateTime? createdAt;

  HotelModel({
    this.id,
    required this.hotelName,
    required this.address,
    required this.city,
    required this.description,
    required this.image,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "hotelName": hotelName,
        "address": address,
        "city": city,
        "description": description,
        "image": image,
        "createdAt": FieldValue.serverTimestamp(),
      };

  factory HotelModel.fromJson(Map<String, dynamic> json, String id) {
    final rawLocation = (json['location'] ?? json['address'] ?? '') as String;
    final parsedCity = (json['city'] ?? '') as String;
    final fallbackImage = (json['coverImagePath'] ?? '') as String;

    return HotelModel(
      id: id,
      hotelName: (json["hotelName"] ?? json['name'] ?? '') as String,
      address: (json["address"] ?? json['location'] ?? '') as String,
      city: parsedCity.isNotEmpty
          ? parsedCity
          : (rawLocation.contains(',')
              ? rawLocation.split(',').last.trim()
              : ''),
      description: (json["description"] ?? json['summary'] ?? '') as String,
      image: (json["image"] ?? fallbackImage) as String,
      createdAt: (json["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
