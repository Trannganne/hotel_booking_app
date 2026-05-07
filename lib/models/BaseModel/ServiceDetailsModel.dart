class ServiceDetailsModel {
  String? id;
  String serviceId;
  String bookingId;
  int quantity;

  ServiceDetailsModel({
    this.id,
    required this.serviceId,
    required this.bookingId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "bookingId": bookingId,
    "quantity": quantity,
  };

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      serviceId: json["serviceId"],
      bookingId: json["bookingId"],
      quantity: json["quantity"],
    );
  }
}
