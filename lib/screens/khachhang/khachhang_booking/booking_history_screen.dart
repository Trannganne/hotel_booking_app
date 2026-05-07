import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_card_widget.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/models_booking/booking_filter_status.dart';
import 'package:hotel_booking_app/models/models_booking/booking_order_ui_model.dart';
import 'package:hotel_booking_app/models/models_booking/booking_status.dart';
import 'package:hotel_booking_app/services/booking_flow_service.dart';

import 'booking_detail_screen.dart';
import '../danhgia_screen.dart';

/// Màn lịch sử đặt phòng của khách hàng.
class BookingHistoryScreen extends StatefulWidget {
  final BookingFlowService service;
  final ValueChanged<int>? onTabChanged;
  final bool showBottomNav;

  const BookingHistoryScreen({
    super.key,
    required this.service,
    this.onTabChanged,
    this.showBottomNav = true,
  });

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final TextEditingController searchController = TextEditingController();

  BookingFilterStatus selectedStatus = BookingFilterStatus.all;
  DateTime? selectedDate = DateTime(2026, 5, 20);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BookingOrderUiModel> bookings = widget.service.getBookings(
      keyword: searchController.text,
      statusFilter: selectedStatus,
      selectedDate: selectedDate,
    );

    return AppScaffoldShell(
      title: 'LỊCH ĐẶT PHÒNG',
      automaticallyImplyLeading: false,
      bottomNavigationBar: widget.showBottomNav
          ? BookingBottomNav(currentIndex: 3, onTap: widget.onTabChanged)
          : null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFE9E9E9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(child: _buildStatusFilter()),
                      const SizedBox(width: 14),
                      Expanded(child: _buildDateFilter()),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (bookings.isEmpty)
                    SectionCard(
                      child: Column(
                        children: const <Widget>[
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 44,
                            color: BookingColors.textSecondary,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Không tìm thấy đơn đặt phù hợp',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...bookings.map(
                      (BookingOrderUiModel booking) => BookingCardWidget(
                        booking: booking,
                        onDetailTap: () async {
                          await Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => BookingDetailScreen(
                                bookingId: booking.id,
                                service: widget.service,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        onReviewTap: booking.status.canReview
                            ? () => Navigator.of(context, rootNavigator: true)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RatingScreen(),
                                    ),
                                  )
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

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Trạng thái',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<BookingFilterStatus>(
          value: selectedStatus,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          items: BookingFilterStatus.values
              .map(
                (BookingFilterStatus item) =>
                    DropdownMenuItem<BookingFilterStatus>(
                      value: item,
                      child: Text(item.label),
                    ),
              )
              .toList(),
          onChanged: (BookingFilterStatus? value) {
            if (value == null) return;
            setState(() => selectedStatus = value);
          },
        ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Ngày',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime now = DateTime.now();
            final DateTime initialDate = selectedDate ?? DateTime(2026, 5, 20);
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(now.year - 2),
              lastDate: DateTime(now.year + 5),
            );
            if (picked != null) {
              setState(() => selectedDate = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BookingColors.lightBorder),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.calendar_month_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Chọn ngày'
                        : widget.service.formatDate(selectedDate!),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => selectedDate = null);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
