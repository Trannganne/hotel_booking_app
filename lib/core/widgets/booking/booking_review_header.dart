import 'package:flutter/material.dart';

/// Header dùng cho màn Thông tin đặt.
class BookingReviewHeader extends StatelessWidget {
  final String hotelName;

  const BookingReviewHeader({
    super.key,
    required this.hotelName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1DA1F2),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  hotelName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _StepCircle(number: '1', isActive: true),
              SizedBox(width: 8),
              Text(
                'Đặt',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 48,
                child: Divider(
                  color: Colors.white70,
                  thickness: 2,
                ),
              ),
              SizedBox(width: 12),
              _StepCircle(number: '2', isActive: false),
              SizedBox(width: 8),
              Text(
                'Thanh toán',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String number;
  final bool isActive;

  const _StepCircle({
    required this.number,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white70,
          width: 2,
        ),
      ),
      child: Text(
        number,
        style: TextStyle(
          color: isActive ? const Color(0xFF1DA1F2) : Colors.white70,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}