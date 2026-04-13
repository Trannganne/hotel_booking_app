/// Model dữ liệu cho màn hình "xem lại thông tin đặt phòng" trước khi thanh toán.
///
/// Màn này chỉ giữ lại 3 nhóm nội dung:
/// 1. Thông tin phòng / khách sạn đã chọn
/// 2. Thông tin khách hàng
/// 3. Chi tiết phí thanh toán
///
/// Lưu ý:
/// - Chưa nối database/API.
/// - Dữ liệu hiện tại được build từ thông tin phòng đã chọn ở màn trước.
/// - Sau này chỉ cần map dữ liệu thật vào model này là dùng lại được toàn bộ UI.
class BookingReviewDataModel {
  final String hotelName;
  final String roomName;
  final String? roomImagePath;

  final String checkInText;
  final String checkOutText;

  final String areaText;
  final String bedText;
  final String breakfastText;
  final String guestText;

  final String roomPriceText;
  final String totalPriceText;

  final String customerName;
  final String loginMethodText;
  final String contactInfoText;
  final String specialRequestText;

  const BookingReviewDataModel({
    required this.hotelName,
    required this.roomName,
    required this.roomImagePath,
    required this.checkInText,
    required this.checkOutText,
    required this.areaText,
    required this.bedText,
    required this.breakfastText,
    required this.guestText,
    required this.roomPriceText,
    required this.totalPriceText,
    required this.customerName,
    required this.loginMethodText,
    required this.contactInfoText,
    required this.specialRequestText,
  });

  /// Tạo bản sao có chỉnh sửa một vài field khi cần.
  BookingReviewDataModel copyWith({
    String? hotelName,
    String? roomName,
    String? checkInText,
    String? checkOutText,
    String? areaText,
    String? bedText,
    String? breakfastText,
    String? guestText,
    String? roomPriceText,
    String? totalPriceText,
    String? customerName,
    String? loginMethodText,
    String? contactInfoText,
    String? specialRequestText,
  }) {
    return BookingReviewDataModel(
      hotelName: hotelName ?? this.hotelName,
      roomName: roomName ?? this.roomName,
      roomImagePath: roomImagePath ?? this.roomImagePath,
      checkInText: checkInText ?? this.checkInText,
      checkOutText: checkOutText ?? this.checkOutText,
      areaText: areaText ?? this.areaText,
      bedText: bedText ?? this.bedText,
      breakfastText: breakfastText ?? this.breakfastText,
      guestText: guestText ?? this.guestText,
      roomPriceText: roomPriceText ?? this.roomPriceText,
      totalPriceText: totalPriceText ?? this.totalPriceText,
      customerName: customerName ?? this.customerName,
      loginMethodText: loginMethodText ?? this.loginMethodText,
      contactInfoText: contactInfoText ?? this.contactInfoText,
      specialRequestText: specialRequestText ?? this.specialRequestText,
    );
  }
}
