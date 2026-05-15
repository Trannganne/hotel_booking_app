import 'package:hotel_booking_app/models/models_booking/booking_review_data_model.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';

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
      roomImagePath: room.imagePath,
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

  BookingReviewDataModel buildFromRoomType({
    required String hotelName,
    required RoomTypeModel roomType,
    required DateTime checkIn,
    required DateTime checkOut,
    required int quantity,
    required int guests,
  }) {
    final totalPrice = roomType.pricePerNight * quantity;

    return BookingReviewDataModel(
      hotelName: hotelName,
      roomName: roomType.roomTypeName,
      roomImagePath: roomType.imagesList.isNotEmpty
          ? roomType.imagesList.first
          : null,
      checkInText: _formatDate(checkIn),
      checkOutText: _formatDate(checkOut),
      areaText: '${roomType.area.toStringAsFixed(1)} m2',
      bedText: '${roomType.bedCount} ${roomType.bedType}',
      breakfastText: 'Không bao gồm bữa sáng',
      guestText: '$guests khách',
      roomPriceText: _formatMoney(roomType.pricePerNight),
      totalPriceText: _formatMoney(totalPrice),
      customerName: '',
      loginMethodText: 'Đã đăng nhập',
      contactInfoText: '',
      specialRequestText: '',
    );
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  String _formatMoney(num value) {
    final text = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final reverseIndex = text.length - i;
      buffer.write(text[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    return '${buffer.toString()} VND';
  }
}
