import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hotel_booking_app/screens/khachhang/khachhang_booking/booking_review_screen.dart';
import '../../khachhang/thanhtoan_screen.dart';
import 'package:hotel_booking_app/services/booking_review_service.dart';

class ChiTietPhongScreen extends StatefulWidget {
  final Map<String, dynamic> room;

  const ChiTietPhongScreen({super.key, required this.room});

  @override
  State<ChiTietPhongScreen> createState() => _ChiTietPhongScreenState();
}

class _ChiTietPhongScreenState extends State<ChiTietPhongScreen> {
  final Color _mainColor = const Color(0xFF0077FF);
  bool _isSaved = false;
  final PageController _pageController = PageController();
  final BookingReviewService _bookingReviewService =
      const BookingReviewService(); // THêm này để tạo instance của BookingReviewService

  // Dummy data for reviews and more images
  final List<String> _roomImages = [
    'assets/images/phong01_01.jpg',
    'assets/images/phong01_02.jpg',
    'assets/images/phong01_03.jpg',
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      'user': 'Nguyễn Văn A',
      'rating': 5,
      'comment': 'Phòng rất đẹp và sạch sẽ!',
    },
    {
      'user': 'Trần Thị B',
      'rating': 4,
      'comment': 'Dịch vụ tốt, nhân viên thân thiện.',
    },
    {
      'user': 'Lê Văn C',
      'rating': 3,
      'comment': 'Giá hơi cao so với tiện nghi.',
    },
    {'user': 'Phạm Thị D', 'rating': 5, 'comment': 'Sẽ quay lại lần nữa!'},
    {'user': 'Hoàng Văn E', 'rating': 2, 'comment': 'Phòng hơi ồn ào.'},
  ];

  final List<Map<String, dynamic>> _similarRooms = [
    {
      'id': 'P005',
      'name': 'Phòng Deluxe View Biển',
      'price': 2800000,
      'rating': 4.6,
      'image': 'assets/images/phong02_01.jpg',
    },
    {
      'id': 'P006',
      'name': 'Phòng Superior Hướng Vườn',
      'price': 2000000,
      'rating': 4.3,
      'image': 'assets/images/phong02_02.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.room['name'],
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
                  const SizedBox(height: 24),
                  _buildSimilarRoomsSection(),
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
          children: (widget.room['amenities'] as List<String>).map((amenity) {
            return Chip(
              label: Text(amenity),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
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
            itemCount: _roomImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle image tap to view fullscreen
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Image.asset(
                        _roomImages[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  _roomImages[index],
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
                widget.room['name'],
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
              onPressed: () {
                setState(() {
                  _isSaved = !_isSaved;
                });
              },
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
                  formatCurrency.format(widget.room['price']),
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

  Widget _buildSimilarRoomsSection() {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'vi_VN',
      name: 'VND',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phòng tương tự',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280, // Increased height to accommodate new card design
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _similarRooms.length,
            itemBuilder: (context, index) {
              final room = _similarRooms[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChiTietPhongScreen(room: room),
                    ),
                  );
                },
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      0.9, // Card takes 90% of screen width
                  child: Card(
                    margin: const EdgeInsets.only(right: 16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: SizedBox(
                            height: 150, // Adjusted image height
                            width: double.infinity,
                            child: Image.asset(
                              room['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.hotel,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('Phường 2, Thành phố Vũng Tàu'),
                                  const Spacer(),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${room['rating']}/5'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${formatCurrency.format(room['price'])}/đêm',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle booking action

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ThanhToanScreen()),
          );
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
