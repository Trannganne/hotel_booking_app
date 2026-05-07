class PolicyModel {
  String? id;
  bool breakfastIncluded;
  bool isRefundable;
  bool canReschedule;

  PolicyModel({
    this.id,
    required this.breakfastIncluded,
    required this.isRefundable,
    required this.canReschedule,
  });

  Map<String, dynamic> toJson() => {
    "breakfastIncluded": breakfastIncluded,
    "isRefundable": isRefundable,
    "canReschedule": canReschedule,
  };

  factory PolicyModel.fromJson(Map<String, dynamic> json, String id) {
    return PolicyModel(
      id: id,
      breakfastIncluded: json["breakfastIncluded"],
      isRefundable: json["isRefundable"],
      canReschedule: json["canReschedule"],
    );
  }
}
