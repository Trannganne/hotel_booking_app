import 'package:flutter/material.dart';

/// Khung card dùng chung cho các khối trong màn Thông tin đặt.
class BookingReviewCardShell extends StatelessWidget {
  final Widget child;

  const BookingReviewCardShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}