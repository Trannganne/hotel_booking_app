import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

import 'booking_history_screen.dart';
import 'hotel_detail_booking_screen.dart';

/// Root screen demo để test nhanh toàn bộ flow phần đặt phòng của khách hàng.
///
/// Khi ghép vào project thật, bạn có thể:
/// - Gọi trực tiếp [HotelDetailBookingScreen]
/// - Hoặc gọi [BookingHistoryScreen]
/// - Hoặc dùng cả [BookingCustomerRootScreen] để demo nhanh
class BookingCustomerRootScreen extends StatefulWidget {
  final BookingFlowService service;

  const BookingCustomerRootScreen({
    super.key,
    required this.service,
  });

  @override
  State<BookingCustomerRootScreen> createState() => _BookingCustomerRootScreenState();
}

class _BookingCustomerRootScreenState extends State<BookingCustomerRootScreen> {
  int currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      _PlaceholderTab(
        title: 'TỔNG QUAN',
        message: 'Tab này đang để trống. Sau này màn Trang chủ tổng của app chỉ cần '
            'gọi class phù hợp là xong.',
      ),
      HotelDetailBookingScreen(service: widget.service),
      _PlaceholderTab(
        title: 'KHÁCH',
        message: 'Tab này đang để trống để không ảnh hưởng phần của thành viên khác.',
      ),
      BookingHistoryScreen(
        service: widget.service,
        onTabChanged: _onTabChanged,
        showBottomNav: false,
      ),
      _PlaceholderTab(
        title: 'PROFILE',
        message: 'Tab này đang để trống để chờ nối với hồ sơ người dùng của nhóm.',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BookingBottomNav(
        currentIndex: currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() => currentIndex = index);
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final String message;

  const _PlaceholderTab({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldShell(
      title: title,
      automaticallyImplyLeading: false,
      body: SingleChildScrollView(
        padding: screenPadding,
        child: SectionCard(
          child: Column(
            children: <Widget>[
              const Icon(
                Icons.widgets_outlined,
                size: 56,
                color: BookingColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: BookingColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
