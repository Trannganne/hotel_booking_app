import 'package:hotel_booking_app/models/models_booking/booking_action_state.dart';
import 'package:hotel_booking_app/models/models_booking/booking_filter_status.dart';
import 'package:hotel_booking_app/models/models_booking/booking_hotel_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_room_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_status.dart';
import 'package:hotel_booking_app/models/models_booking/hotel_review_ui_model.dart';

/// Service quản lý toàn bộ dữ liệu tạm của module đặt phòng.
///
/// Lưu ý:
/// - Chưa lấy dữ liệu từ API / database.
/// - Dữ liệu hiện tại được gán cứng để phục vụ làm giao diện và luồng nghiệp vụ.
/// - Khi nối dữ liệu thật, bạn chỉ cần thay phần seed data trong service này.
class BookingFlowService {
  BookingFlowService() {
    _seedStaticData();
  }

  late BookingHotelUiModel _hotel;
  final List<BookingRoomUiModel> _rooms = <BookingRoomUiModel>[];
  final List<BookingOrderUiModel> _bookings = <BookingOrderUiModel>[];

  /// Khởi tạo dữ liệu tĩnh cho module.
  void _seedStaticData() {
    const hotelId = 'hotel_sun_hill';

    _hotel = const BookingHotelUiModel(
      id: hotelId,
      name: 'Khách sạn Sun Hill Vũng Tàu',
      location: 'Vũng Tàu, Bà Rịa - Vũng Tàu',
      rating: 8.9,
      reviewCount: 87,
      coverImagePath: 'assets/images/sun_hill.jpg',
      // TODO: Tự thêm ảnh khách sạn vào đây.
      // Ví dụ: 'assets/igames/sun_hill_cover.jpg'
      highlights: <String>[
        'Vị trí thuận tiện',
        'Khu mua sắm gần',
        'Gần khu vui chơi giải trí',
      ],
      amenities: <String>[
        'Máy lạnh',
        'Lễ tân 24h',
        'Chỗ đậu xe',
        'Wi-Fi',
      ],
      reviews: <HotelReviewUiModel>[
        HotelReviewUiModel(
          reviewerName: 'Nguyễn Văn A',
          reviewTimeText: '2 tháng trước',
          content: 'Khách sạn sạch sẽ, đẹp nhưng cách biển hơi xa một chút. '
              'Nhân viên thân thiện, tiện đi lại và xung quanh có nhiều quán ăn.',
        ),
        HotelReviewUiModel(
          reviewerName: 'Lê Thị B',
          reviewTimeText: '3 tuần trước',
          content: 'Phòng ổn, vị trí dễ tìm, phù hợp cho chuyến đi ngắn ngày cùng gia đình.',
        ),
      ],
    );

    _rooms
      ..clear()
      ..addAll(const <BookingRoomUiModel>[
        BookingRoomUiModel(
          id: 'room_1',
          hotelId: hotelId,
          code: 'P101',
          name: 'Suite Có Tầm Nhìn Ra Núi',
          shortDescription: '1 giường cỡ queen · 20.0 m² · 2 khách/phòng',
          imagePath: 'assets/images/phong01.jpg',
          // TODO: Tự thêm ảnh loại phòng tại đây.
          // Ví dụ: 'assets/igames/room_suite.jpg'
          areaText: '20.0 m²',
          bedText: '1 giường cỡ queen',
          viewText: 'Mountain View',
          smokingText: 'Non Smoking',
          breakfastText: 'Không bao gồm bữa sáng',
          capacityText: '2 khách/phòng',
          pricePerNight: 328734,
          finalPrice: 379689,
          roomAmenities: <String>[
            'Máy lạnh',
            'Nước đóng chai miễn phí',
            'TV',
            'Bàn làm việc',
          ],
          bathroomAmenities: <String>[
            'Nước nóng',
            'Phòng tắm riêng',
            'Vòi tắm đứng',
            'Bộ vệ sinh cá nhân',
            'Áo choàng tắm',
            'Máy sấy tóc',
          ],
          policies: <String>[
            'Không hoàn tiền',
            'Không đổi lịch',
          ],
        ),
        BookingRoomUiModel(
          id: 'room_2',
          hotelId: hotelId,
          code: 'P205',
          name: 'Superior Double Room',
          shortDescription: '1 giường đôi · 22.0 m² · 2 khách/phòng',
          imagePath: 'assets/images/phong02.jpg',
          // TODO: Tự thêm ảnh loại phòng tại đây.
          areaText: '22.0 m²',
          bedText: '1 giường đôi',
          viewText: 'Mountain View',
          smokingText: 'Non Smoking',
          breakfastText: 'Breakfast not included',
          capacityText: '2 khách/phòng',
          pricePerNight: 358734,
          finalPrice: 409689,
          roomAmenities: <String>[
            'Máy lạnh',
            'TV',
            'Minibar',
            'Bàn làm việc',
          ],
          bathroomAmenities: <String>[
            'Nước nóng',
            'Phòng tắm riêng',
            'Bộ vệ sinh cá nhân',
            'Máy sấy tóc',
          ],
          policies: <String>[
            'Không hoàn tiền',
            'Không đổi lịch',
          ],
        ),
        BookingRoomUiModel(
          id: 'room_3',
          hotelId: hotelId,
          code: 'P305',
          name: 'Presidential Suite',
          shortDescription: '1 giường lớn · 35.0 m² · 2 khách/phòng',
          imagePath: 'assets/images/phong03.jpg',
          // TODO: Tự thêm ảnh loại phòng tại đây.
          areaText: '35.0 m²',
          bedText: '1 giường lớn',
          viewText: 'City View',
          smokingText: 'Non Smoking',
          breakfastText: 'Bao gồm bữa sáng',
          capacityText: '2 khách/phòng',
          pricePerNight: 828734,
          finalPrice: 899689,
          roomAmenities: <String>[
            'Máy lạnh',
            'TV màn hình lớn',
            'Bồn tắm',
            'Ban công',
          ],
          bathroomAmenities: <String>[
            'Nước nóng',
            'Bồn tắm riêng',
            'Bộ vệ sinh cá nhân cao cấp',
            'Máy sấy tóc',
          ],
          policies: <String>[
            'Không hoàn tiền',
            'Không đổi lịch',
          ],
        ),
      ]);

    _bookings
      ..clear()
      ..addAll(<BookingOrderUiModel>[
        BookingOrderUiModel(
          id: 'booking_1',
          bookingCode: 'BK-91234',
          hotelId: hotelId,
          hotelName: _hotel.name,
          hotelImagePath: 'assets/images/sun_hill.jpg',
          // TODO: Tự thêm ảnh khách sạn cho booking tại đây.
          roomId: 'room_1',
          roomCode: 'P101',
          roomName: 'Suite Có Tầm Nhìn Ra Núi',
          roomTypeBadge: 'OCEAN SUITE',
          guestText: '2 người lớn',
          checkIn: DateTime(2026, 3, 23),
          checkOut: DateTime(2026, 3, 26),
          pricePerNight: 328734,
          extraFee: 5000,
          paidTotal: 1037157,
          status: BookingStatus.pending,
          cancelReason: null,
        ),
        BookingOrderUiModel(
          id: 'booking_2',
          bookingCode: 'BK-91235',
          hotelId: hotelId,
          hotelName: _hotel.name,
          hotelImagePath: 'assets/images/sun_hill.jpg',
          roomId: 'room_2',
          roomCode: 'P205',
          roomName: 'Superior Double Room',
          roomTypeBadge: 'DELUXE',
          guestText: '2 người lớn',
          checkIn: DateTime(2026, 4, 10),
          checkOut: DateTime(2026, 4, 12),
          pricePerNight: 358734,
          extraFee: 0,
          paidTotal: 717468,
          status: BookingStatus.confirmed,
          cancelReason: null,
        ),
        BookingOrderUiModel(
          id: 'booking_3',
          bookingCode: 'BK-91236',
          hotelId: hotelId,
          hotelName: _hotel.name,
          hotelImagePath: 'assets/images/sun_hill.jpg',
          roomId: 'room_3',
          roomCode: 'P305',
          roomName: 'Presidential Suite',
          roomTypeBadge: 'PREMIUM',
          guestText: '2 người lớn',
          checkIn: DateTime(2026, 5, 20),
          checkOut: DateTime(2026, 5, 23),
          pricePerNight: 828734,
          extraFee: 0,
          paidTotal: 2486202,
          status: BookingStatus.completed,
          cancelReason: null,
        ),
        BookingOrderUiModel(
          id: 'booking_4',
          bookingCode: 'BK-91237',
          hotelId: hotelId,
          hotelName: _hotel.name,
          hotelImagePath: 'assets/images/sun_hill.jpg',
          roomId: 'room_1',
          roomCode: 'P101',
          roomName: 'Suite Có Tầm Nhìn Ra Núi',
          roomTypeBadge: 'STANDARD',
          guestText: '2 người lớn',
          checkIn: DateTime(2026, 6, 1),
          checkOut: DateTime(2026, 6, 3),
          pricePerNight: 328734,
          extraFee: 0,
          paidTotal: 657468,
          status: BookingStatus.cancelled,
          cancelReason: 'Lý do cá nhân',
        ),
      ]);
  }

  /// Lấy thông tin khách sạn đang được chọn.
  BookingHotelUiModel getHotel() => _hotel;

  /// Lấy danh sách loại phòng của khách sạn.
  List<BookingRoomUiModel> getRooms() {
    return List<BookingRoomUiModel>.from(_rooms);
  }

  /// Lấy chi tiết một loại phòng.
  BookingRoomUiModel getRoomById(String roomId) {
    return _rooms.firstWhere((BookingRoomUiModel room) => room.id == roomId);
  }

  /// Lấy danh sách booking theo từ khóa, trạng thái và ngày.
  List<BookingOrderUiModel> getBookings({
    String keyword = '',
    BookingFilterStatus statusFilter = BookingFilterStatus.all,
    DateTime? selectedDate,
  }) {
    final lowerKeyword = keyword.trim().toLowerCase();

    return _bookings.where((BookingOrderUiModel booking) {
      final matchKeyword = lowerKeyword.isEmpty ||
          booking.hotelName.toLowerCase().contains(lowerKeyword) ||
          booking.bookingCode.toLowerCase().contains(lowerKeyword) ||
          booking.roomName.toLowerCase().contains(lowerKeyword);

      final matchStatus = statusFilter.valueOrNull == null ||
          booking.status == statusFilter.valueOrNull;

      final matchDate = selectedDate == null ||
          !_onlyDate(selectedDate).isBefore(_onlyDate(booking.checkIn)) &&
              !_onlyDate(selectedDate).isAfter(_onlyDate(booking.checkOut));

      return matchKeyword && matchStatus && matchDate;
    }).toList();
  }

  /// Lấy chi tiết một booking.
  BookingOrderUiModel getBookingById(String bookingId) {
    return _bookings.firstWhere((BookingOrderUiModel item) => item.id == bookingId);
  }

  /// Lấy quyền thao tác của booking.
  BookingActionState getActionState(String bookingId) {
    final booking = getBookingById(bookingId);

    return BookingActionState(
      canCancel: booking.status.canCancel,
      canChangeRoom: booking.status.canChangeRoom,
      canReview: booking.status.canReview,
    );
  }

  /// Lấy danh sách phòng có thể đổi sang.
  List<BookingRoomUiModel> getAlternativeRooms(String bookingId) {
    final booking = getBookingById(bookingId);
    return _rooms.where((BookingRoomUiModel room) => room.id != booking.roomId).toList();
  }

  /// Hủy đơn đặt phòng.
  void cancelBooking({
    required String bookingId,
    required String reason,
  }) {
    final index = _bookings.indexWhere((BookingOrderUiModel item) => item.id == bookingId);
    if (index == -1) return;

    final current = _bookings[index];
    _bookings[index] = current.copyWith(
      status: BookingStatus.cancelled,
      cancelReason: reason,
    );
  }

  /// Đổi phòng cho booking.
  void changeRoom({
    required String bookingId,
    required String newRoomId,
  }) {
    final bookingIndex = _bookings.indexWhere((BookingOrderUiModel item) => item.id == bookingId);
    if (bookingIndex == -1) return;

    final selectedRoom = getRoomById(newRoomId);
    final currentBooking = _bookings[bookingIndex];

    final newPaidTotal = (selectedRoom.pricePerNight * currentBooking.totalNights) +
        currentBooking.extraFee;

    _bookings[bookingIndex] = currentBooking.copyWith(
      roomId: selectedRoom.id,
      roomCode: selectedRoom.code,
      roomName: selectedRoom.name,
      pricePerNight: selectedRoom.pricePerNight,
      paidTotal: newPaidTotal,
    );
  }

  /// Tính chênh lệch khi đổi sang phòng khác.
  int calculateRoomDifference({
    required String bookingId,
    required String candidateRoomId,
  }) {
    final booking = getBookingById(bookingId);
    final candidateRoom = getRoomById(candidateRoomId);
    return candidateRoom.pricePerNight - booking.pricePerNight;
  }

  /// Kiểm tra lý do hủy hợp lệ.
  bool isValidCancelReason(String? reason) {
    return reason != null && reason.trim().isNotEmpty;
  }

  /// Format số tiền cho UI.
  String formatCurrency(int value) {
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

  /// Format ngày kiểu dd/MM/yyyy.
  String formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }

  DateTime _onlyDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
