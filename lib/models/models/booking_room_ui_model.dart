/// Model UI tạm cho loại phòng.
class BookingRoomUiModel {
  final String id;
  final String hotelId;
  final String name;
  final String? image;
  final String areaText;
  final String bedText;
  final String viewText;
  final String smokingText;
  final String breakfastText;
  final String priceText;
  final String finalPriceText;
  final List<String> roomAmenities;
  final List<String> bathroomAmenities;
  final List<String> policies;

  const BookingRoomUiModel({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.image,
    required this.areaText,
    required this.bedText,
    required this.viewText,
    required this.smokingText,
    required this.breakfastText,
    required this.priceText,
    required this.finalPriceText,
    required this.roomAmenities,
    required this.bathroomAmenities,
    required this.policies,
  });
}
