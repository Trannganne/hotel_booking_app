import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:hotel_booking_app/core/widgets/booking/app_scaffold_shell.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_bottom_nav.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_card_widget.dart';
import 'package:hotel_booking_app/core/widgets/booking/booking_constants.dart';
import 'package:hotel_booking_app/core/widgets/booking/section_card.dart';
import 'package:hotel_booking_app/models/BaseModel/BookingModel.dart';
import 'package:hotel_booking_app/models/BaseModel/PaymentModel.dart';
import 'package:hotel_booking_app/screens/khachhang/khachhang_booking/booking_detail_screen.dart';
import 'package:hotel_booking_app/services/booking_service/booking_service.dart';
import '../review/reviewScreen.dart';

// FIle này chỉ để test phần đánh giá dựa trên show lịch sử booking vì màn hình Rating
//yêu cầu truyền vào 1 booking đã hoàn tất
//RatingScreen(booking: booking)
// Khi nào chức năng show lịch sử booking hoàn chỉnh thì sẽ xóa

class BookingHistoryScreen extends StatefulWidget {
  final BookingService service;
  final String userId;
  final ValueChanged<int>? onTabChanged;
  final bool showBottomNav;

  const BookingHistoryScreen({
    super.key,
    required this.service,
    required this.userId,
    this.onTabChanged,
    this.showBottomNav = true,
  });

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  final BookingController controller = BookingController();

  String search = "";
  String status = "all";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        search = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookingModel>>(
      stream: widget.service.streamBookingsByUser(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffoldShell(
            title: 'LỊCH ĐẶT PHÒNG',
            automaticallyImplyLeading: false,
            bottomNavigationBar: widget.showBottomNav
                ? BookingBottomNav(currentIndex: 3, onTap: widget.onTabChanged)
                : null,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Lỗi tải đơn đặt: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppScaffoldShell(
            title: 'LỊCH ĐẶT PHÒNG',
            automaticallyImplyLeading: false,
            bottomNavigationBar: widget.showBottomNav
                ? BookingBottomNav(currentIndex: 3, onTap: widget.onTabChanged)
                : null,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data ?? [];

        final bookings = controller.filter(
          source: data,
          keyword: search,
          status: status,
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
                      _buildSearchField(),
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
                        const SectionCard(
                          child: Column(
                            children: <Widget>[
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
                        ...bookings.map((booking) {
                          return FutureBuilder(
                            future: Future.wait([
                              controller.getRoomTypeForBooking(booking),
                              controller.getPaymentForBooking(booking),
                            ]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final results = snapshot.data as List<dynamic>?;

                              final roomType = results?[0];
                              final payment = results?[1] as PaymentModel?;

                              return BookingCardWidget(
                                booking: booking, // BookingModel
                                roomType: roomType,
                                orderCode: payment?.orderCode ?? "N/A",
                                onDetailTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingDetailScreen(
                                        booking: booking,
                                        orderCode: payment?.orderCode ?? "N/A",
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                                onReviewTap: _canReview(booking)
                                    ? () =>
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).push(
                                            MaterialPageRoute(
                                              builder: (_) => RatingScreen(
                                                booking: booking,
                                              ),
                                            ),
                                          )
                                    : null,
                              );
                            },
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= SEARCH =================
  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
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
    );
  }

  // ================= STATUS FILTER =================
  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Trạng thái',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: status,
          items: const [
            DropdownMenuItem(value: "all", child: Text("Tất cả")),
            DropdownMenuItem(value: "pending", child: Text("Chờ xác nhận")),
            DropdownMenuItem(value: "confirmed", child: Text("Đã xác nhận")),
            DropdownMenuItem(value: "completed", child: Text("Hoàn tất")),
            DropdownMenuItem(value: "cancelled", child: Text("Đã huỷ")),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => status = value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  // ================= DATE FILTER =================
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
            final now = DateTime.now();

            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? now,
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
                        ? "Chọn ngày"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => selectedDate = null),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= REVIEW CHECK =================
  bool _canReview(BookingModel booking) {
    return booking.bookingStatus == "completed";
  }
}
