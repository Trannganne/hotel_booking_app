import 'package:flutter/material.dart';
import 'screens/khachhang/dangnhap_screen.dart';
import 'screens/khachhang/dangky_screen.dart';
import 'screens/khachhang/trangchu/trangchu_screen.dart';
import 'screens/admin/quanly_dondatphong/ql_don_screen.dart';

void main() {
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
