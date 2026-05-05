import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/admin/policy/policyController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/services/notification_service/thongbao_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/khachhang/auth/dangnhap_screen.dart';
import 'screens/khachhang/danhgia/danhgia_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init(); // Khởi tạo dịch vụ thông báo
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomTypeController()),
        ChangeNotifierProvider(create: (_) => Policycontroller()),
        ChangeNotifierProvider(create: (_) => AmenityController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HotelBank',
      debugShowCheckedModeBanner: false,

      home: const DangNhapScreen(),
      //home: const RatingScreen(),
    );
  }
}
