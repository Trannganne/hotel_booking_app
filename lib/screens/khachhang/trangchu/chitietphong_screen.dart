import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/policy/policyController.dart';
import 'package:hotel_booking_app/controllers/auth/AuthContronller.dart';
import 'package:hotel_booking_app/controllers/khachhang/booking/bookingController.dart';
import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/models/models_booking_ui/booking_review_data_model.dart';
import 'package:hotel_booking_app/screens/khachhang/khachhang_booking/booking_review_screen.dart';
import 'package:intl/intl.dart';
import '../payment/paymentScreen.dart';
import 'package:hotel_booking_app/controllers/khachhang/favourite/favourite_controller.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/FavouriteModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/OtherModel/requestbooking/requestBookingModel.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/DateTimePicker/chon_ngay_screen.dart';

class ChiTietPhongScreen extends StatefulWidget {
  final RoomTypeModel roomType;
  final List<Amenitymodel> amenities;

  const ChiTietPhongScreen({
    super.key,
    required this.roomType,
    required this.amenities,
  });

  @override
  State<ChiTietPhongScreen> createState() => _ChiTietPhongScreenState();
}

class _ChiTietPhongScreenState extends State<ChiTietPhongScreen> {
  final Color _mainColor = const Color(0xFF0077FF);

  bool _isSaved = false;
  bool _isLoading = false;

  final PageController _pageController = PageController();
  final FavouriteController _favouriteController = FavouriteController();

  List<FavouriteModel> _favourites = [];
  PolicyModel? _policy;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _favouriteController.getAll();

      _favourites = List.from(_favouriteController.favourites);
      // Kiểm tra xem phòng hiện tại đã được yêu thích hay chưa
      _isSaved = _favourites.any((fav) => fav.roomTypeId == widget.roomType.id);

      // Lấy policy của roomtype
      _policy = await context.read<Policycontroller>().getPolicyById(
        widget.roomType.id!,
      );
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavourite() async {
    final roomTypeId = widget.roomType.id;
    if (roomTypeId == null || roomTypeId.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final existingFavouriteIndex = _favourites.indexWhere(
        (fav) => fav.roomTypeId == roomTypeId,
      );

      if (existingFavouriteIndex >= 0) {
        final favouriteId = _favourites[existingFavouriteIndex].id;
        if (favouriteId != null && favouriteId.isNotEmpty) {
          await _favouriteController.removeFavourite(favouriteId);
          _favourites.removeAt(existingFavouriteIndex);
          _isSaved = false;
        }
      } else {
        final newFavourite = FavouriteModel(userId: '', roomTypeId: roomTypeId);
        await _favouriteController.addFavourite(newFavourite);

        // Đồng bộ lại list để lấy đúng id document từ Firestore.
        await _favouriteController.getAll();
        _favourites = List.from(_favouriteController.favourites);
        _isSaved = _favourites.any((fav) => fav.roomTypeId == roomTypeId);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật yêu thích: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.roomType.roomTypeName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: _mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoomHeaderAndDetails(),
                  const SizedBox(height: 16),
                  const Text(
                    'Mô tả',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đây là một căn phòng tuyệt vời với đầy đủ tiện nghi, tầm nhìn đẹp và không gian thoáng đãng. Phù hợp cho các cặp đôi hoặc gia đình nhỏ đi du lịch và nghỉ dưỡng.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _buildConveniences(),
                  const SizedBox(height: 24),
                  _buildBathroomAmenities(),
                  const SizedBox(height: 24),
                  _buildCancellationPolicy(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingButton(),
    );
  }

  Widget _buildConveniences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiện nghi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children:
              (widget.amenities.map((amenity) => amenity.amenityName).toList()
                      as List<String>)
                  .map((amenity) {
                    return Chip(
                      label: Text(amenity),
                      backgroundColor: Colors.grey[200],
                    );
                  })
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildBathroomAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trang bị phòng tắm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: ['Vòi sen', 'Khăn tắm', 'Dầu gội', 'Xà phòng'].map((
            amenity,
          ) {
            return Chip(
              label: Text(amenity),
              avatar: const Icon(Icons.check, color: Colors.green),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chính sách hủy phòng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Miễn phí hủy phòng trong vòng 48 giờ trước thời gian nhận phòng. Nếu hủy sau thời gian này, bạn sẽ phải thanh toán 50% tổng giá trị đặt phòng.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.roomType.imagesList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle image tap to view fullscreen
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Image.network(
                        widget.roomType.imagesList[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                child: Image.network(
                  widget.roomType.imagesList[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        Positioned(
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomHeaderAndDetails() {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'vi_VN',
      name: 'VND',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.roomType.roomTypeName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isSaved ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 30,
              ),
              onPressed: _isLoading ? null : _toggleFavourite,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2 khách/phòng',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency.format(widget.roomType.pricePerNight),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  '/phòng/đêm',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Text(
                  'Chưa bao gồm thuế và phí',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () async {
          // Open date selection screen (pass room max occupancy)
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (_) => ChonNgayScreen(
                initialCheckIn: DateTime.now(),
                initialCheckOut: DateTime.now().add(const Duration(days: 1)),
                maxOccupancy: widget.roomType.maxOccupancy,
                roomTypeId: widget.roomType.id,
              ),
            ),
          );

          if (result != null) {
            final selectedCheckIn =
                result['checkIn'] as DateTime? ?? DateTime.now();
            final selectedCheckOut =
                result['checkOut'] as DateTime? ??
                DateTime.now().add(const Duration(days: 1));
            final guests = result['guests'] as int? ?? 1;
            final quantity = result['quantity'] as int? ?? 1;

            final authController = context.read<Authcontronller>();

            // --- PHANH AN TOÀN 1: KIỂM TRA UID ĐĂNG NHẬP ---
            if (authController.uid == null) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vui lòng đăng nhập để thực hiện đặt phòng!'),
                ),
              );
              return;
            }

            // --- PHANH AN TOÀN 2: ÉP TẢI USERMODEL NẾU ĐANG NULL ---
            if (authController.userModel == null) {
              // Hiển thị thông báo hoặc bật loading nhẹ trong lúc đợi
              await authController.fetchCurrentUserProfile();
            }

            // --- PHANH AN TOÀN 3: ÉP TẢI POLICY NẾU ĐANG NULL ---
            if (_policy == null) {
              try {
                // Giả sử bạn gọi qua controller hoặc service tương ứng của nhóm bạn
                final policyController = context.read<Policycontroller>();
                _policy = await policyController.getPolicyById(
                  widget.roomType.policyId ?? '',
                );
              } catch (e) {
                print("Không lấy được policy tự động: $e");
              }
            }

            // --- BƯỚC ĐÁNH GIÁ CUỐI CÙNG TRƯỚC KHI ĐÓNG GÓI ---
            if (authController.userModel == null || _policy == null) {
              print("=== DEBUG ĐẶT PHÒNG ===");
              if (authController.userModel == null) {
                print("LỖI: authController.userModel đang bị NULL!");
              } else {
                print("OK: authController.userModel đã có dữ liệu.");
              }

              if (_policy == null) {
                print("LỖI: Biến _policy của phòng này đang bị NULL!");
              } else {
                print("OK: _policy đã có dữ liệu.");
              }
              print("=======================");
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Hệ thống đang tải dữ liệu cấu hình, vui lòng bấm lại sau ít giây!',
                  ),
                ),
              );
              return; // Chặn đứng luồng không cho đi tiếp, tránh lỗi sập app
            }

            // 2. Tạo requestBooking sau khi các biến kiểm tra đã hoàn toàn an toàn
            final requestBooking = CreateBookingRequest(
              userId: authController.uid!, // Đã kiểm tra null ở Phanh 1
              roomTypeId: widget.roomType.id ?? '',
              checkIn: selectedCheckIn,
              checkOut: selectedCheckOut,
              quantity: quantity,
            );

            if (!mounted) return;

            // 3. Đóng gói an toàn tuyệt đối không dùng dấu ! mù quáng
            final bookingPreviewData = BookingPreviewModel(
              bookingRequest: requestBooking,
              roomType: widget.roomType,
              user: authController.userModel!, // Đã được bảo vệ bởi Phanh 2
              policy: _policy!, // Đã được bảo vệ bởi Phanh 3
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingPreviewScreen(data: bookingPreviewData),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _mainColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        child: const Text('Đặt phòng', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
