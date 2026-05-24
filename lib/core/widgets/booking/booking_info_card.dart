import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_review_card_shell.dart';
import 'package:hotel_booking_app/models/models_booking_ui/booking_review_data_model.dart';
import 'package:intl/intl.dart';

/// Card hiển thị thông tin phòng đã chọn.
class BookingInfoCard extends StatelessWidget {
  final BookingPreviewModel data;

  const BookingInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Định dạng ngày hiển thị: dd/MM/yyyy (Ví dụ: 24/05/2026)
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Định dạng tiền tệ VND: (Ví dụ: 1.500.000 ₫)
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: 'vi_VN',
      name: 'VND',
    );

    // Kiểm tra xem chính sách có bữa sáng không, hoàn tiền đổi lịch không
    final bool isBreakfastIncluded = data.policy?.breakfastIncluded ?? false;
    final bool isRefundable = data.policy?.isRefundable ?? false;
    final bool canReschedule = data.policy?.canReschedule ?? false;

    return BookingReviewCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.roomType.imagesList.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                data.roomType.imagesList.first,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              const Icon(Icons.apartment_rounded, color: Color(0xFF4B5563)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.roomType.roomTypeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _infoRow(
            'Nhận phòng',
            dateFormat.format(data.bookingRequest.checkIn),
          ),
          const SizedBox(height: 10),
          _infoRow(
            'Trả phòng',
            dateFormat.format(data.bookingRequest.checkOut),
          ),
          const SizedBox(height: 10),
          _infoRow('Số đêm nghỉ', '${data.totalNights} đêm'),
          const SizedBox(height: 10),
          _infoRow('Số lượng phòng', '${data.bookingRequest.quantity} phòng'),
          const Divider(height: 28),

          // Chi tiết đặc điểm phòng
          Text(
            "Thông tin chi tiết",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          _featureRow(Icons.straighten_rounded, data.roomType.area.toString()),
          const SizedBox(height: 10),
          _featureRow(Icons.bed_outlined, data.roomType.bedType),
          const SizedBox(height: 10),
          _featureRow(
            isBreakfastIncluded
                ? Icons.restaurant_outlined
                : Icons.no_meals_outlined,
            isBreakfastIncluded
                ? 'Bữa ăn: Có bao gồm bữa ăn sáng'
                : 'Bữa ăn: Không bao gồm bữa ăn sáng',
          ),
          Divider(height: 1),
          _featureRow(
            isRefundable ? Icons.currency_exchange : Icons.block,
            isRefundable ? 'Có hoàn tiền' : 'Không hoàn tiền',
          ),
          _featureRow(
            canReschedule ? Icons.currency_exchange : Icons.block,
            canReschedule ? 'Có đổi lịch' : 'Không đổi lịch',
          ),
          const SizedBox(height: 10),
          _featureRow(
            Icons.group_outlined,
            data.roomType.maxOccupancy.toString(),
          ),
          const Divider(height: 28),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Giá phòng',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                currencyFormat.format(data.totalRoomPrice),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE63E57),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String left, String right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(fontSize: 16, color: Color(0xFF111827)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            right,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
