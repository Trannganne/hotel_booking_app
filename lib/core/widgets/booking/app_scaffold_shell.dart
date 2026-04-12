import 'package:flutter/material.dart';

import 'booking_constants.dart';

/// Scaffold shell dùng lại cho các màn booking.
///
/// Mục tiêu:
/// - đồng bộ AppBar
/// - đồng bộ background
/// - tránh lặp code giữa nhiều screen
class AppScaffoldShell extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  const AppScaffoldShell({
    super.key,
    required this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingColors.background,
      appBar: AppBar(
        backgroundColor: BookingColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
