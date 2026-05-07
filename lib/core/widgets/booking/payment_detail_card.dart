import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_review_card_shell.dart';
import 'package:hotel_booking_app/models/models_booking/booking_review_data_model.dart';

/// Card chi tiết phí thanh toán.
class PaymentDetailCard extends StatelessWidget {
  final BookingReviewDataModel data;

  const PaymentDetailCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BookingReviewCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết phí thanh toán',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          _priceRow('Giá phòng', data.roomPriceText),
          const SizedBox(height: 10),
          _priceRow('Phí dịch vụ', '0 VND'),
          const Divider(height: 28),
          _priceRow('Tổng giá tiền', data.totalPriceText, isTotal: true),
        ],
      ),
    );
  }

  Widget _priceRow(String left, String right, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(
              fontSize: isTotal ? 17 : 15,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.w800,
            color: isTotal
                ? const Color(0xFF111827)
                : const Color(0xFFE63E57),
          ),
        ),
      ],
    );
  }
}