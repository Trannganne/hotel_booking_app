import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceDetailsModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceModel.dart';

class BookingViewModel {
  final BookingModel booking;
  final RoomModel? room;
  final RoomTypeModel roomType;
  final PaymentModel? payment;
  final List<Amenitymodel> amenities;
  final List<ServiceDetailsModel>? serviceDetails;
  final List<ServiceModel>? services;

  // Hiển thị giá
  final int nights;
  final double roomFee;
  final double serviceFee;
  final double totalPrice;

  BookingViewModel({
    required this.booking,
    this.room,
    required this.roomType,
    this.payment,
    required this.amenities,
    this.serviceDetails,
    this.services,
    required this.nights,
    required this.roomFee,
    required this.serviceFee,
    required this.totalPrice,
  });

  // Tiền phòng gốc
  double get roomPrice => booking.totalPrice ?? 0;

  // Tổng tiền các dịch vụ phát sinh( do admin thêm)
  double get totalExtraServicesPrice {
    if (serviceDetails == null || services == null) return 0.0;

    return serviceDetails!.fold(0.0, (sum, detail) {
      // Tìm xem chi tiết này thuộc dịch vụ( serviceModel) nào
      final service = services!.firstWhere(
        (s) => s.id == detail.serviceId,
        orElse: () => ServiceModel(id: '', serviceName: '', price: 0.0),
      );

      return sum + (detail.quantity * service.price);
    });
  }

  // Tổng số đơn thực tế cuối cùng khách cần thanh toán
  double get finalInvoiceTotal => roomPrice + totalExtraServicesPrice;

  // Số tiền khách đã thanh toán trước( qua chuyển khoản)
  double get amountPaidBefore {
    if (payment!.status == "pending") return 0.0;

    return roomPrice;
  }

  // Số tiền còn lại cần phải thu của khách
  double get remainingAmountToPay {
    final remaining = finalInvoiceTotal - amountPaidBefore;

    return remaining < 0 ? 0.0 : remaining;
  }

  // Trạng thái kiểm tra để hiển thị UI
  String get paymentMethodText {
    if (payment == null) return "Thanh toán trực tiếp tại quầy (Trả sau)";
    return "Đã chuyển khoản trước tiền phòng (Trả trước)";
  }
}
