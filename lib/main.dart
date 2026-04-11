import 'package:flutter/material.dart';
import 'screens/khachhang/dangnhap_screen.dart';
import 'screens/khachhang/dangky_screen.dart';

void main() {
  runApp(MyApp());
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
