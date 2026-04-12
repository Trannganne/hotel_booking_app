/// Model UI tạm cho màn chi tiết khách sạn.
///
/// Hiện đang dùng mock data để dựng giao diện.
/// Sau này có thể map từ API / database sang model này.
class BookingHotelUiModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviewCount;
  final String? coverImage;
  final List<String> highlights;
  final List<String> amenities;

  const BookingHotelUiModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.coverImage,
    required this.highlights,
    required this.amenities,
  });
}
