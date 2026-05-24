/// Model hiển thị loại phòng.
class BookingRoomUiModel {
  final String id;
  final String hotelId;
  final String code;
  final String name;
  final String shortDescription;

  /// Đường dẫn ảnh local của loại phòng.
  ///
  /// Ví dụ sau này bạn tự thêm:
  /// assets/igames/room_suite.jpg
  final String? imagePath;

  final String areaText;
  final String bedText;
  final String viewText;
  final String smokingText;
  final String breakfastText;
  final String capacityText;
  final int pricePerNight;
  final int finalPrice;
  final List<String> roomAmenities;
  final List<String> bathroomAmenities;
  final List<String> policies;

  const BookingRoomUiModel({
    required this.id,
    required this.hotelId,
    required this.code,
    required this.name,
    required this.shortDescription,
    required this.imagePath,
    required this.areaText,
    required this.bedText,
    required this.viewText,
    required this.smokingText,
    required this.breakfastText,
    required this.capacityText,
    required this.pricePerNight,
    required this.finalPrice,
    required this.roomAmenities,
    required this.bathroomAmenities,
    required this.policies,
  });

  /// Giá hiển thị ở list phòng.
  String get priceText => _formatCurrency(pricePerNight);

  /// Giá cuối cùng hiển thị ở chi tiết phòng.
  String get finalPriceText => _formatCurrency(finalPrice);

  static String _formatCurrency(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return 'VND ${buffer.toString()}';
  }
}
