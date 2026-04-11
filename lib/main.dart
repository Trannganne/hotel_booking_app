import 'package:flutter/material.dart';
import 'package:hotel_booking_app/services/thongbao_service.dart';

import 'screens/khachhang/dangnhap_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Khởi tạo dịch vụ thông báo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const DangNhapScreen(),
    );
  }
}
