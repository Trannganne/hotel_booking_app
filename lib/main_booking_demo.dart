import 'package:flutter/material.dart';
import 'package:hotel_booking_app/screens/khachhang/khachhang_booking/booking_customer_root_screen.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

/// File chạy demo riêng cho module đặt phòng.
///
/// Khi ghép vào project thật, bạn có thể bỏ file này đi và gọi thẳng
/// [BookingCustomerRootScreen] hoặc từng screen riêng trong module.
void main() {
  runApp(const BookingDemoApp());
}

/// App demo tối giản để test toàn bộ flow phần đặt phòng khách hàng.
class BookingDemoApp extends StatelessWidget {
  const BookingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking Demo',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: const Color(0xFF0077FF),
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
        fontFamily: 'Roboto',
      ),
      home: BookingCustomerRootScreen(
        service: BookingFlowService(),
      ),
    );
  }
}
