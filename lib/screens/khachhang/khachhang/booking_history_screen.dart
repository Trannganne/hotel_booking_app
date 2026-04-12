import 'package:flutter/material.dart';

import 'package:hotel_booking_app/models/models/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models/booking_status.dart';
import 'package:hotel_booking_app/services/booking_mock_service.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_card_widget.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'booking_detail_screen.dart';
import 'booking_handoff_placeholder_screen.dart';

/// Màn lịch sử / danh sách đặt phòng của khách hàng.
///
/// Screen này chỉ giữ state của bộ lọc UI.
/// Logic lọc và tìm kiếm được chuyển vào service.
class BookingHistoryScreen extends StatefulWidget {
  final BookingMockService service;

  const BookingHistoryScreen({
    super.key,
    required this.service,
  });

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  /// Trạng thái đang chọn ở dropdown.
  BookingStatus? selectedStatus;

  /// Ngày đang dùng để lọc.
  String selectedDate = '';

  /// Controller cho ô search.
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Danh sách booking sau khi đã được service xử lý filter/search.
  List<BookingOrderUiModel> get filteredBookings {
    return widget.service.searchAndFilterBookings(
      status: selectedStatus,
      date: selectedDate,
      keyword: searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookings = filteredBookings;

    return AppScaffoldShell(
      title: 'LỊCH ĐẶT PHÒNG',
      bottomNavigationBar: const BookingBottomNav(currentIndex: 3),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ô tìm kiếm booking theo tên khách sạn hoặc mã booking.
                  SectionCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hàng bộ lọc trạng thái + ngày.
                  Row(
                    children: [
                      Expanded(
                        child: _FilterBox(
                          label: 'Trạng thái',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<BookingStatus?>(
                              value: selectedStatus,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(16),
                              items: [
                                const DropdownMenuItem<BookingStatus?>(
                                  value: null,
                                  child: Text('Tất cả'),
                                ),
                                ...BookingStatus.values.map(
                                  (status) => DropdownMenuItem<BookingStatus?>(
                                    value: status,
                                    child: Text(status.label),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => selectedStatus = value);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FilterBox(
                          label: 'Ngày',
                          child: InkWell(
                            onTap: _pickDate,
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    selectedDate.isEmpty ? 'Chọn ngày' : selectedDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Danh sách booking.
                  if (bookings.isEmpty)
                    const SectionCard(
                      child: Text(
                        'Không có đơn đặt phù hợp với bộ lọc hiện tại.',
                        style: TextStyle(
                          color: BookingColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    )
                  else
                    ...bookings.map(
                      (booking) => BookingCardWidget(
                        booking: booking,
                        onDetailTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingDetailScreen(
                                bookingId: booking.id,
                                service: widget.service,
                              ),
                            ),
                          );
                        },
                        onReviewTap: booking.status == BookingStatus.completed
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BookingHandoffPlaceholderScreen(
                                      title: 'Màn đánh giá',
                                      message:
                                          'Đây là điểm handoff tạm cho màn đánh giá. Sau này nối với phần đánh giá thật của nhóm.',
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mở date picker và lưu ngày lọc dưới format dd/MM/yyyy.
  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 3),
    );

    if (picked != null) {
      setState(() {
        selectedDate = widget.service.formatBookingDate(picked);
      });
    }
  }
}

/// Box filter dùng lại cho khu vực bộ lọc.
class _FilterBox extends StatelessWidget {
  final String label;
  final Widget child;

  const _FilterBox({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        SectionCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: child,
        ),
      ],
    );
  }
}
