class ServiceModel {
  String? id;
  String serviceName;
  double price;

  ServiceModel({this.id, required this.serviceName, required this.price});

  Map<String, dynamic> toJson() => {"serviceName": serviceName, "price": price};

  factory ServiceModel.fromJson(Map<String, dynamic> json, String id) {
    return ServiceModel(
      id: id,
      serviceName: json["serviceName"],
      price: (json["price"] as num).toDouble(),
    );
  }
}
