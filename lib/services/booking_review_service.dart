import 'package:hotel_booking_app/models/models_booking/booking_review_data_model.dart';

/// Service chịu trách nhiệm build dữ liệu cho màn Thông tin đặt.
///
/// Theo đúng README:
/// - Logic xử lý dữ liệu nên nằm ở Services
/// - Screen chỉ nên nhận dữ liệu và hiển thị
class BookingReviewService {
  const BookingReviewService();

  /// Tạo dữ liệu cho màn review từ phòng đã chọn.
  ///
  /// Vì model phòng thật của project bạn có thể khác nhau,
  /// nên ở đây dùng kiểu dynamic để bạn dễ ghép.
  /// Sau này bạn có thể đổi sang đúng model phòng hiện tại.
  BookingReviewDataModel buildFromSelectedRoom({
    required String hotelName,
    required dynamic room,
  }) {
    return BookingReviewDataModel(
      hotelName: hotelName,
      roomName: room.name ?? '',
      roomImagePath: room.imagePath ?? null,
      checkInText: 'Th 3, 28 thg 4 2026 (14:00)',
      checkOutText: 'CN, 3 thg 5 2026 (12:00)',
      areaText: room.areaText ?? '',
      bedText: room.bedText ?? '',
      breakfastText: room.breakfastText ?? '',
      guestText: '2 khách/phòng',
      roomPriceText: room.priceText ?? '',
      totalPriceText: room.finalPriceText ?? room.priceText ?? '',
      customerName: 'Phạm Duy Thông',
      loginMethodText: 'Đã đăng nhập bằng Google',
      contactInfoText: '',
      specialRequestText: '',
    );
  }
}