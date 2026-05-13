import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      title: 'Sunrise Hotel Booking',
      debugShowCheckedModeBanner: false,
      //Set up vị trí để đổi datetimepicker thành tiếng Việt
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const DangNhapScreen(),
    );
  }
}
