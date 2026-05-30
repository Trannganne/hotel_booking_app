import 'booking_status.dart';

/// Model hiển thị đơn đặt phòng trong lịch sử booking.
class BookingOrderUiModel {
  final String id;
  final String bookingCode;
  final String hotelId;
  final String hotelName;

  /// Đường dẫn ảnh local của khách sạn trong đơn đặt.
  ///
  /// Ví dụ sau này bạn tự thêm:
  /// assets/igames/sun_hill_cover.jpg
  final String? hotelImagePath;

  final String roomId;
  final String roomCode;
  final String roomName;
  final String roomTypeBadge;
  final String guestText;
  final DateTime checkIn;
  final DateTime checkOut;
  final int pricePerNight;
  final int extraFee;
  final int paidTotal;
  final BookingStatus status;
  final String? cancelReason;

  const BookingOrderUiModel({
    required this.id,
    required this.bookingCode,
    required this.hotelId,
    required this.hotelName,
    required this.hotelImagePath,
    required this.roomId,
    required this.roomCode,
    required this.roomName,
    required this.roomTypeBadge,
    required this.guestText,
    required this.checkIn,
    required this.checkOut,
    required this.pricePerNight,
    required this.extraFee,
    required this.paidTotal,
    required this.status,
    required this.cancelReason,
  });

  /// Số đêm ở.
  int get totalNights => checkOut.difference(checkIn).inDays;

  /// Tiền phòng trước phụ phí.
  int get roomTotal => pricePerNight * totalNights;

  /// Chuỗi ngày check-in.
  String get checkInDateText => _formatDate(checkIn);

  /// Chuỗi ngày check-out.
  String get checkOutDateText => _formatDate(checkOut);

  /// Chuỗi thời gian ở.
  String get stayDateText => '${_formatDate(checkIn)} - ${_formatDate(checkOut)}';

  /// Chuỗi giờ check-in mặc định để hiển thị UI.
  String get checkInTimeText => '14:00';

  /// Chuỗi số đêm ở để hiển thị.
  String get totalNightsText => '$totalNights đêm';

  /// Giá mỗi đêm.
  String get pricePerNightText => _formatCurrency(pricePerNight);

  /// Phụ phí.
  String get extraFeeText => _formatCurrency(extraFee);

  /// Tổng tiền hiển thị.
  String get paidTotalText => _formatCurrency(paidTotal);

  /// Tên phòng ghép mã phòng.
  String get roomDisplayText => '$roomCode - $roomName';

  BookingOrderUiModel copyWith({
    String? roomId,
    String? roomCode,
    String? roomName,
    int? pricePerNight,
    int? paidTotal,
    BookingStatus? status,
    String? cancelReason,
  }) {
    return BookingOrderUiModel(
      id: id,
      bookingCode: bookingCode,
      hotelId: hotelId,
      hotelName: hotelName,
      hotelImagePath: hotelImagePath,
      roomId: roomId ?? this.roomId,
      roomCode: roomCode ?? this.roomCode,
      roomName: roomName ?? this.roomName,
      roomTypeBadge: roomTypeBadge,
      guestText: guestText,
      checkIn: checkIn,
      checkOut: checkOut,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      extraFee: extraFee,
      paidTotal: paidTotal ?? this.paidTotal,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  static String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }

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
