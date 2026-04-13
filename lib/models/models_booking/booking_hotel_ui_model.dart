import 'hotel_review_ui_model.dart';

/// Model hiển thị thông tin khách sạn ở module đặt phòng.
class BookingHotelUiModel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviewCount;

  /// Đường dẫn ảnh local của khách sạn.
  ///
  /// Ví dụ sau này bạn tự thêm:
  /// assets/igames/sun_hill_cover.jpg
  final String? coverImagePath;

  final List<String> highlights;
  final List<String> amenities;
  final List<HotelReviewUiModel> reviews;

  const BookingHotelUiModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.coverImagePath,
    required this.highlights,
    required this.amenities,
    required this.reviews,
  });
}
