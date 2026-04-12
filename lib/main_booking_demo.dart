import 'package:flutter/material.dart';

import 'screens/khachhang/khachhang_booking/booking_customer_root_screen.dart';

/// File entry riêng để demo toàn bộ module đặt phòng.
///
/// Khi ghép vào project thật, bạn có thể bỏ file này và điều hướng trực tiếp
/// từ trang chủ chung sang các screen tương ứng.
void main() {
  runApp(const BookingDemoApp());
}

/// App demo tối giản cho module đặt phòng.
class BookingDemoApp extends StatelessWidget {
  const BookingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking Module Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0077FF)),
      ),
      home: const BookingCustomerRootScreen(),
    );
  }
}
