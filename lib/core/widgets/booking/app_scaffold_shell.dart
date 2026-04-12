import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';

/// Scaffold dùng chung cho các màn trong module đặt phòng.
class AppScaffoldShell extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppScaffoldShell({
    super.key,
    required this.title,
    required this.body,
    this.bottomNavigationBar,
    this.automaticallyImplyLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingColors.background,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: BookingColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: automaticallyImplyLeading,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        actions: actions,
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
