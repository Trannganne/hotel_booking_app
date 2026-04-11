import 'package:flutter/material.dart';
import '../screens/khachhang/main_screen.dart'; // đường dẫn
import '../screens/admin/ql_danhgia_screen.dart'; // đường dẫn
import '../../services/thongbao_service.dart'; // Đường dẫn đến NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Thanh Toán Khách Sạn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF0077FF)),
      home: const MainScreen(),
    );
  }
}
