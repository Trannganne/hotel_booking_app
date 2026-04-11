import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_booking_app/screens/khachhang/trangchu/chitietphong_screen.dart';
import 'package:intl/intl.dart';

class TrangChuScreen extends StatefulWidget {
  const TrangChuScreen({super.key});

  @override
  State<TrangChuScreen> createState() => _TrangChuScreenState();
}

class _TrangChuScreenState extends State<TrangChuScreen> {
  final Color _mainColor = const Color(0xFF0077FF);
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _sortOrder = 'none';
  RangeValues _priceRange = const RangeValues(0, 5000000);
  int? _selectedRating = 0;
  final List<String> _selectedAmenities = [];

  // Dummy data for rooms
  final List<Map<String, dynamic>> _rooms = [
    {
      'id': 'P001',
      'name': 'Phòng Suite',
      'price': 328734,
      'rating': 4.5,
      'image': 'assets/images/phong01_01.jpg',
      'images': [
        'assets/images/phong01_01.jpg',
        'assets/images/phong01_02.jpg',
        'assets/images/phong01_03.jpg',
      ],
      'bookings': 150,
      'amenities': ['Wi-Fi Miễn Phí', 'Hướng Núi', 'Bữa Sáng', 'Không Hút Thuốc', 'Trung Tâm Thể Dục', 'Giường Cỡ Queen'],
      'adults': 2,
    },
    {
      'id': 'P002',
      'name': 'Phòng Superior Giường Đôi',
      'price': 280000,
      'rating': 4.2,
      'image': 'assets/images/phong02_01.jpg',
       'images': [
        'assets/images/phong02_01.jpg',
        'assets/images/phong02_02.jpg',
        'assets/images/phong02_03.jpg',
      ],
      'bookings': 200,
      'amenities': ['Wi-Fi Miễn Phí', 'Hướng Núi', 'Không bao gồm bữa sáng', 'Không Hút Thuốc', 'Trung Tâm Thể Dục', 'Giường Cỡ Queen'],
      'adults': 2,
    },
    {
      'id': 'P003',
      'name': 'Phòng Standard',
      'price': 1200000,
      'rating': 3.8,
      'image': 'assets/images/phong01_01.jpg',
       'images': [
        'assets/images/phong01_01.jpg',
        'assets/images/phong01_02.jpg',
        'assets/images/phong01_03.jpg',
      ],
      'bookings': 120,
      'amenities': ['Quạt', 'Tủ lạnh'],
      'adults': 2,
    },
    {
      'id': 'P004',
      'name': 'Phòng Suite',
      'price': 4000000,
      'rating': 4.8,
      'image': 'assets/images/phong02_01.jpg',
       'images': [
        'assets/images/phong02_01.jpg',
        'assets/images/phong02_02.jpg',
        'assets/images/phong02_03.jpg',
      ],
      'bookings': 80,
      'amenities': ['Máy lạnh', 'Tủ lạnh', 'TV', 'Bồn tắm'],
      'adults': 2,
    },
  ];

  final List<Map<String, dynamic>> _reviews = [
    {'user': 'Nguyễn Văn A', 'rating': 5, 'comment': 'Khách sạn sạch sẽ, đẹp nhưng cách biển hơi xa 1 tí nhưng không đáng lo ngại vì xung quanh đó có rất nhiều quán ăn, cafe các bạn đi dạo cũng thú vị.'},
    {'user': 'Trần Thị B', 'rating': 4, 'comment': 'Dịch vụ tốt, nhân viên thân thiện.'},
  ];

  List<Map<String, dynamic>> _filteredRooms = [];

  @override
  void initState() {
    super.initState();
    _filteredRooms = List.from(_rooms);
    _minPriceController.text = _priceRange.start.round().toString();
    _maxPriceController.text = _priceRange.end.round().toString();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _filterRooms(String query) {
    setState(() {
      _filteredRooms = _rooms.where((room) {
        final nameMatches = room['name'].toLowerCase().contains(query.toLowerCase());
        final idMatches = room['id'].toLowerCase().contains(query.toLowerCase());
        final priceMatches = room['price'] >= _priceRange.start && room['price'] <= _priceRange.end;
        final ratingMatches = room['rating'] >= (_selectedRating ?? 0);
        final amenitiesMatch = _selectedAmenities.every((amenity) => room['amenities'].contains(amenity));
        return (nameMatches || idMatches) && priceMatches && ratingMatches && amenitiesMatch;
      }).toList();
      _sortRooms();
    });
  }

  void _sortRooms() {
    setState(() {
      if (_sortOrder == 'price_asc') {
        _filteredRooms.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (_sortOrder == 'price_desc') {
        _filteredRooms.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (_sortOrder == 'popularity') {
        _filteredRooms.sort((a, b) => b['bookings'].compareTo(a['bookings']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: _mainColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: const Text(
                'Khách sạn Sun Hill Vũng Tàu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Image.asset(
                'assets/images/banner.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: _mainColor),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHotelInfo(),
                  const SizedBox(height: 16),
                  _buildHotelAmenities(),
                  const SizedBox(height: 24),
                  _buildReviewsSection(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 8),
                  Text(
                    'Các Phòng Có Sẵn',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RoomCard(room: _filteredRooms[index]);
              },
              childCount: _filteredRooms.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                '4.5/5', 
                style: TextStyle(
                  color: _mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'Xuất sắc',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _mainColor),
              ),
              const Text(
                '87 đánh giá',
                style: TextStyle(color: Colors.black, fontSize: 12), 
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vị trí thuận tiện',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _mainColor),
            ),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.shopping_bag_outlined, 'Khu mua sắm', color: _mainColor),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.gamepad_outlined, 'Gần khu vui chơi giải trí', color: _mainColor),
          ],
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.map_outlined, color: _mainColor),
          label: Text('Bản đồ', style: TextStyle(color: _mainColor)),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? Colors.black54),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildHotelAmenities() {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAmenityItem(Icons.ac_unit, 'Máy lạnh'),
              _buildAmenityItem(Icons.support_agent, 'Lễ tân 24h'),
              _buildAmenityItem(Icons.local_parking, 'Chỗ đậu xe'),
              _buildAmenityItem(Icons.wifi, 'Wifi miễn phí'),
              _buildAmenityItem(Icons.restaurant, 'Nhà hàng'),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward_ios, color: _mainColor, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: Row(

        children: [
          Icon(icon, color: _mainColor, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Đánh giá (87)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Handle "View All" tap
              },
              child: Text('Xem tất cả', style: TextStyle(color: _mainColor)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              return _buildReviewCard(_reviews[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Text('Avatar'),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['user'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        review['rating'],
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '2 phút trước', // Dummy timestamp
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              review['comment'],
              style: const TextStyle(color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm phòng...',
                suffixIcon: const Icon(Icons.search, color: Color(0xFF0077FF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: _mainColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: _mainColor, width: 2.0),
                ),
              ),
              onChanged: _filterRooms,
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt, color: _mainColor),
            onPressed: () => _showFilterDialog(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortOrder = value;
                _sortRooms();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'price_asc',
                child: Text('Giá tăng dần'),
              ),
              const PopupMenuItem<String>(
                value: 'price_desc',
                child: Text('Giá giảm dần'),
              ),
              const PopupMenuItem<String>(
                value: 'popularity',
                child: Text('Phổ biến nhất'),
              ),
            ],
            icon: Icon(Icons.sort, color: _mainColor),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bộ lọc'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Khoảng giá'),
                      TextFormField(
                        controller: _minPriceController,
                        decoration: const InputDecoration(labelText: 'Giá thấp nhất'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập giá';
                          }
                          final price = int.tryParse(value);
                          if (price == null) {
                            return 'Giá không hợp lệ';
                          }
                          if (price < 0) {
                            return 'Giá không được âm';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _maxPriceController,
                        decoration: const InputDecoration(labelText: 'Giá cao nhất'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập giá';
                          }
                          final maxPrice = int.tryParse(value);
                          if (maxPrice == null) {
                            return 'Giá không hợp lệ';
                          }
                          final minPrice = int.tryParse(_minPriceController.text);
                          if (minPrice != null && maxPrice < minPrice) {
                            return 'Giá cao nhất phải lớn hơn giá thấp nhất';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Đánh giá'),
                      Wrap(
                        spacing: 0,
                        runSpacing: 0,
                        children: [1, 2, 3, 4, 5].map((rating) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<int>(
                                value: rating,
                                groupValue: _selectedRating,
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedRating = value;
                                  });
                                },
                                activeColor: _mainColor,
                              ),
                              Text('$rating'),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                            ],
                          );
                        }).toList(),
                      ),
                      const Text('Tiện ích'),
                      ...['Máy lạnh', 'Tủ lạnh', 'TV', 'Bồn tắm'].map((amenity) {
                        return CheckboxListTile(
                          title: Text(amenity),
                          value: _selectedAmenities.contains(amenity),
                          activeColor: _mainColor,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _priceRange = RangeValues(
                      double.parse(_minPriceController.text),
                      double.parse(_maxPriceController.text),
                    );
                  });
                  Navigator.of(context).pop();
                  _filterRooms(_searchController.text);
                }
              },
              child: const Text('Áp dụng'),
            ),
          ],
        );
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN', name: 'VND');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChiTietPhongScreen(room: room),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                room['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.hotel, size: 100, color: Colors.grey),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAmenitiesGrid(room['amenities']),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('${room['adults']} người', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatCurrency.format(room['price']),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Tổng tiền: ${formatCurrency.format(room['price'] * 1.1)}', // Example with tax
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChiTietPhongScreen(room: room),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Đặt phòng', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesGrid(List<String> amenities) {
    // Helper to get icons for amenities
    IconData _getIconForAmenity(String amenity) {
      switch (amenity.toLowerCase()) {
        case 'free wi-fi':
          return Icons.wifi;
        case 'mountain view':
          return Icons.terrain;
        case 'breakfast':
          return Icons.free_breakfast;
        case 'non smoking':
          return Icons.smoke_free;
        case 'fitness center':
          return Icons.fitness_center;
        case 'queen size bed':
          return Icons.king_bed;
        default:
          return Icons.check_box_outline_blank;
      }
    }

    return Table(
      children: [
        for (int i = 0; i < amenities.length; i += 2)
          TableRow(
            children: [
              _buildAmenityEntry(_getIconForAmenity(amenities[i]), amenities[i]),
              if (i + 1 < amenities.length)
                _buildAmenityEntry(_getIconForAmenity(amenities[i + 1]), amenities[i + 1])
              else
                Container(), // Empty container for alignment if odd number of amenities
            ],
          ),
      ],
    );
  }

  Widget _buildAmenityEntry(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
