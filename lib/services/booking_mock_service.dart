import 'package:hotel_booking_app/models/models/booking_action_state.dart';
import 'package:hotel_booking_app/models/models/booking_hotel_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_room_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_status.dart';

/// Service mock của module đặt phòng.
///
/// Theo đúng README của project:
/// - Service là nơi chứa business logic.
/// - Service là nơi thao tác dữ liệu.
///
/// Hiện tại chưa nối database/API nên toàn bộ dữ liệu là mock data.
/// Sau này chỉ cần thay phần mock bằng API hoặc database,
/// còn screen gần như giữ nguyên.
class BookingMockService {
  const BookingMockService();

  // ---------------------------------------------------------------------------
  // HOTEL
  // ---------------------------------------------------------------------------

  /// Lấy thông tin chi tiết khách sạn.
  BookingHotelUiModel getHotelDetail(String hotelId) {
    return BookingHotelUiModel(
      id: hotelId,
      name: 'Khách sạn Sun Hill Vũng Tàu',
      location: 'Vũng Tàu, Bà Rịa - Vũng Tàu',
      rating: 8.9,
      reviewCount: 87,
      coverImage: null,
      highlights: const [
        'Vị trí thuận tiện',
        'Khu mua sắm gần',
        'Gần khu vui chơi giải trí',
      ],
      amenities: const [
        'Máy lạnh',
        'Lễ tân 24h',
        'Chỗ đậu xe',
        'Wi-Fi',
      ],
    );
  }

  /// Lấy danh sách loại phòng theo khách sạn.
  List<BookingRoomUiModel> getRoomsByHotel(String hotelId) {
    return List<BookingRoomUiModel>.unmodifiable([
      BookingRoomUiModel(
        id: 'room_1',
        hotelId: hotelId,
        name: 'Suite Có Tầm Nhìn Ra Núi',
        image: null,
        areaText: '20.0 m²',
        bedText: '1 giường cỡ queen',
        viewText: 'Mountain View',
        smokingText: 'Non Smoking',
        breakfastText: 'Không bao gồm bữa sáng',
        priceText: 'VND 328.734',
        finalPriceText: 'VND 379.689',
        roomAmenities: const [
          'Máy lạnh',
          'Nước đóng chai miễn phí',
          'TV',
          'Bàn làm việc',
        ],
        bathroomAmenities: const [
          'Nước nóng',
          'Phòng tắm riêng',
          'Vòi tắm đứng',
          'Bộ vệ sinh cá nhân',
          'Áo choàng tắm',
          'Máy sấy tóc',
        ],
        policies: const ['Không hoàn tiền', 'Không đổi lịch'],
      ),
      BookingRoomUiModel(
        id: 'room_2',
        hotelId: hotelId,
        name: 'Superior Double Room',
        image: null,
        areaText: '22.0 m²',
        bedText: '1 giường đôi lớn',
        viewText: 'City View',
        smokingText: 'Non Smoking',
        breakfastText: 'Breakfast not included',
        priceText: 'VND ---.---',
        finalPriceText: 'VND ---.---',
        roomAmenities: const [
          'Máy lạnh',
          'TV',
          'Tủ quần áo',
          'Bàn làm việc',
        ],
        bathroomAmenities: const [
          'Nước nóng',
          'Phòng tắm riêng',
          'Máy sấy tóc',
        ],
        policies: const ['Không hoàn tiền', 'Không đổi lịch'],
      ),
      BookingRoomUiModel(
        id: 'room_3',
        hotelId: hotelId,
        name: 'Presidential Suite',
        image: null,
        areaText: '35.0 m²',
        bedText: '1 giường king',
        viewText: 'Balcony',
        smokingText: 'Non Smoking',
        breakfastText: 'Bao gồm bữa sáng',
        priceText: 'VND ---.---',
        finalPriceText: 'VND ---.---',
        roomAmenities: const [
          'Máy lạnh',
          'Wi-Fi',
          'Bồn tắm',
          'Minibar',
        ],
        bathroomAmenities: const [
          'Nước nóng',
          'Bồn tắm riêng',
          'Máy sấy tóc',
        ],
        policies: const ['Không hoàn tiền', 'Không đổi lịch'],
      ),
    ]);
  }

  /// Lấy chi tiết một loại phòng cụ thể.
  BookingRoomUiModel getRoomDetail(String hotelId, String roomId) {
    final rooms = getRoomsByHotel(hotelId);
    return rooms.firstWhere(
      (room) => room.id == roomId,
      orElse: () => rooms.first,
    );
  }

  // ---------------------------------------------------------------------------
  // BOOKING DATA
  // ---------------------------------------------------------------------------

  /// Lấy danh sách booking mock để hiển thị ở màn lịch đặt phòng.
  List<BookingOrderUiModel> getBookings() {
    return const [
      BookingOrderUiModel(
        id: 'booking_1',
        bookingCode: 'BK-91234',
        hotelName: 'Khách sạn Sun Hill Vũng Tàu',
        roomName: 'Ocean Suite',
        roomCode: 'P101',
        hotelImage: null,
        status: BookingStatus.checkedIn,
        checkInDate: '23/03/2026',
        checkOutDate: '26/03/2026',
        stayText: '3 đêm',
        nightlyPriceText: '328.734 VND',
        totalPriceText: '1.037.157 VND',
        totalActualText: '1.037.157 VND',
        roomInfoText: '1x Suite Room With Bathtub',
        amenities: [
          'Free Wi-Fi',
          'Mountain View',
          'Breakfast not included',
          'Non Smoking',
          'Fitness Center',
          'Queen Size Bed',
          '2 adults',
          'Balcony',
        ],
        policies: ['Không hoàn tiền', 'Không đổi lịch'],
        adults: 2,
      ),
      BookingOrderUiModel(
        id: 'booking_2',
        bookingCode: 'BK-91235',
        hotelName: 'Khách sạn Sun Hill Vũng Tàu',
        roomName: 'Ocean Suite',
        roomCode: 'P101',
        hotelImage: null,
        status: BookingStatus.cancelled,
        checkInDate: '23/03/2026',
        checkOutDate: '26/03/2026',
        stayText: '3 đêm',
        nightlyPriceText: '328.734 VND',
        totalPriceText: '1.037.157 VND',
        totalActualText: '1.037.157 VND',
        roomInfoText: '1x Suite Room With Bathtub',
        amenities: [
          'Free Wi-Fi',
          'Mountain View',
          'Breakfast not included',
          'Non Smoking',
          'Fitness Center',
          'Queen Size Bed',
        ],
        policies: ['Không hoàn tiền', 'Không đổi lịch'],
        adults: 2,
      ),
      BookingOrderUiModel(
        id: 'booking_3',
        bookingCode: 'BK-91236',
        hotelName: 'Khách sạn Sun Hill Vũng Tàu',
        roomName: 'Ocean Suite',
        roomCode: 'P101',
        hotelImage: null,
        status: BookingStatus.completed,
        checkInDate: '23/03/2026',
        checkOutDate: '26/03/2026',
        stayText: '3 đêm',
        nightlyPriceText: '328.734 VND',
        totalPriceText: '1.037.157 VND',
        totalActualText: '1.037.157 VND',
        roomInfoText: '1x Suite Room With Bathtub',
        amenities: [
          'Free Wi-Fi',
          'Mountain View',
          'Breakfast not included',
          'Non Smoking',
          'Fitness Center',
          'Queen Size Bed',
        ],
        policies: ['Không hoàn tiền', 'Không đổi lịch'],
        adults: 2,
      ),
      BookingOrderUiModel(
        id: 'booking_4',
        bookingCode: 'BK-91237',
        hotelName: 'Khách sạn Sun Hill Vũng Tàu',
        roomName: 'Ocean Suite',
        roomCode: 'P101',
        hotelImage: null,
        status: BookingStatus.pending,
        checkInDate: '23/03/2026',
        checkOutDate: '26/03/2026',
        stayText: '3 đêm',
        nightlyPriceText: '328.734 VND',
        totalPriceText: '1.037.157 VND',
        totalActualText: '1.037.157 VND',
        roomInfoText: '1x Suite Room With Bathtub',
        amenities: [
          'Free Wi-Fi',
          'Mountain View',
          'Breakfast not included',
          'Non Smoking',
          'Fitness Center',
          'Queen Size Bed',
        ],
        policies: ['Không hoàn tiền', 'Không đổi lịch'],
        adults: 2,
      ),
    ];
  }

  /// Lấy chi tiết một booking theo id.
  BookingOrderUiModel getBookingDetail(String bookingId) {
    final bookings = getBookings();
    return bookings.firstWhere(
      (booking) => booking.id == bookingId,
      orElse: () => bookings.first,
    );
  }

  /// Lọc + tìm kiếm booking.
  ///
  /// Logic này thuộc service thay vì screen.
  List<BookingOrderUiModel> searchAndFilterBookings({
    BookingStatus? status,
    String? date,
    String keyword = '',
  }) {
    final normalizedKeyword = keyword.trim().toLowerCase();

    return getBookings().where((booking) {
      final matchesStatus = status == null || booking.status == status;
      final matchesDate = date == null || date.isEmpty || booking.checkInDate == date;
      final matchesKeyword =
          normalizedKeyword.isEmpty ||
          booking.hotelName.toLowerCase().contains(normalizedKeyword) ||
          booking.bookingCode.toLowerCase().contains(normalizedKeyword);

      return matchesStatus && matchesDate && matchesKeyword;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // FORMAT / DISPLAY SUPPORT
  // ---------------------------------------------------------------------------

  /// Format DateTime thành chuỗi dd/MM/yyyy.
  String formatBookingDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Trả về tên thứ tiếng Việt từ chuỗi dd/MM/yyyy.
  String getWeekdayLabel(String ddMMyyyy) {
    final parts = ddMMyyyy.split('/');
    if (parts.length != 3) {
      return '--';
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return '--';
    }

    final date = DateTime(year, month, day);

    switch (date.weekday) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.saturday:
        return 'Thứ Bảy';
      case DateTime.sunday:
        return 'Chủ Nhật';
      default:
        return '--';
    }
  }

  /// Trả về khoảng ngày ngắn gọn cho màn đổi phòng.
  String buildShortDateRange(BookingOrderUiModel booking) {
    final checkIn = booking.checkInDate.split('/');
    final checkOut = booking.checkOutDate.split('/');

    if (checkIn.length != 3 || checkOut.length != 3) {
      return '${booking.checkInDate} - ${booking.checkOutDate}';
    }

    return '${checkIn[0]}/${checkIn[1]} - ${checkOut[0]}/${checkOut[1]}';
  }

  // ---------------------------------------------------------------------------
  // BUSINESS RULES
  // ---------------------------------------------------------------------------

  /// Trả về tập quyền thao tác hợp lệ của booking.
  BookingActionState getBookingActionState(BookingOrderUiModel booking) {
    switch (booking.status) {
      case BookingStatus.pending:
      case BookingStatus.confirmed:
        return const BookingActionState(
          canCancel: true,
          canChangeRoom: true,
          canReview: false,
        );
      case BookingStatus.completed:
        return const BookingActionState(
          canCancel: false,
          canChangeRoom: false,
          canReview: true,
        );
      case BookingStatus.checkedIn:
      case BookingStatus.cancelled:
        return const BookingActionState(
          canCancel: false,
          canChangeRoom: false,
          canReview: false,
        );
    }
  }

  /// Kiểm tra lý do hủy có hợp lệ hay không.
  String? validateCancelReason(String? reason) {
    if (reason == null || reason.trim().isEmpty) {
      return 'Vui lòng chọn hoặc nhập lý do hủy phòng.';
    }
    return null;
  }

  /// Tạo thông báo mock khi hủy booking.
  String buildCancelBookingMessage({
    required BookingOrderUiModel booking,
    required String reason,
  }) {
    return 'Mock action: đơn ${booking.bookingCode} đã ghi nhận yêu cầu hủy với lý do "$reason".';
  }

  // ---------------------------------------------------------------------------
  // CHANGE ROOM
  // ---------------------------------------------------------------------------

  /// Lấy danh sách phòng thay thế cho booking hiện tại.
  List<BookingRoomUiModel> getAlternativeRoomsForBooking(String bookingId) {
    getBookingDetail(bookingId);

    return List<BookingRoomUiModel>.unmodifiable([
      BookingRoomUiModel(
        id: 'alt_1',
        hotelId: 'hotel_1',
        name: 'Presidential Suite',
        image: null,
        areaText: '35.0 m²',
        bedText: '1 giường king',
        viewText: 'Sea View',
        smokingText: 'Non Smoking',
        breakfastText: 'Bao gồm bữa sáng',
        priceText: '+ 500.000 VND / đêm',
        finalPriceText: 'VND ---.---',
        roomAmenities: const ['Máy lạnh', 'Bồn tắm', 'Minibar'],
        bathroomAmenities: const ['Bồn tắm riêng', 'Máy sấy tóc'],
        policies: const ['Đổi phòng tùy tình trạng trống'],
      ),
      BookingRoomUiModel(
        id: 'alt_2',
        hotelId: 'hotel_1',
        name: 'Executive Suite',
        image: null,
        areaText: '30.0 m²',
        bedText: '1 giường king',
        viewText: 'City View',
        smokingText: 'Non Smoking',
        breakfastText: 'Bao gồm bữa sáng',
        priceText: '+ 300.000 VND / đêm',
        finalPriceText: 'VND ---.---',
        roomAmenities: const ['Máy lạnh', 'Wi-Fi', 'Bàn làm việc'],
        bathroomAmenities: const ['Phòng tắm riêng'],
        policies: const ['Đổi phòng tùy tình trạng trống'],
      ),
      BookingRoomUiModel(
        id: 'alt_3',
        hotelId: 'hotel_1',
        name: 'Deluxe Twin Room',
        image: null,
        areaText: '28.0 m²',
        bedText: '2 giường đơn',
        viewText: 'City View',
        smokingText: 'Non Smoking',
        breakfastText: 'Không bao gồm bữa sáng',
        priceText: '+ 150.000 VND / đêm',
        finalPriceText: 'VND ---.---',
        roomAmenities: const ['Máy lạnh', 'Wi-Fi'],
        bathroomAmenities: const ['Phòng tắm riêng'],
        policies: const ['Đổi phòng tùy tình trạng trống'],
      ),
    ]);
  }

  /// Tìm phòng thay thế theo id.
  BookingRoomUiModel? findAlternativeRoomById({
    required String bookingId,
    required String? roomId,
  }) {
    if (roomId == null || roomId.isEmpty) {
      return null;
    }

    final alternatives = getAlternativeRoomsForBooking(bookingId);

    for (final room in alternatives) {
      if (room.id == roomId) {
        return room;
      }
    }

    return null;
  }

  /// Tạo nhãn handoff sang màn placeholder / thanh toán sau khi đổi phòng.
  String buildChangeRoomHandoffLabel(BookingRoomUiModel room) {
    return 'Đổi sang: ${room.name}';
  }
}
