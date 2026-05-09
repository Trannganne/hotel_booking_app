import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/khachhang/hotel/hotelController.dart';
import 'package:hotel_booking_app/controllers/khachhang/danhgia_phanhoi/danhgia_controller.dart';

import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/HotelModel.dart';
import 'package:hotel_booking_app/models/models_booking/hotel_review_ui_model.dart';
import 'package:hotel_booking_app/core/widgets/roomType/roomTypeCard.dart';
import 'package:hotel_booking_app/core/widgets/google_maps/google_maps.dart';
import 'package:hotel_booking_app/screens/khachhang/trangchu/chitietphong_screen.dart';

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

  final RoomTypeController _roomTypeController = RoomTypeController();
  final AmenityController _amenityController = AmenityController();
  final HotelController _hotelController = HotelController();
  final ReviewController _danhGiaController = ReviewController();

  final List<String> _selectedAmenities = [];

  List<RoomTypeModel> _roomTypes = [];
  List<RoomTypeModel> _filteredRoomTypes = [];
  List<Amenitymodel> _amenities = [];

  // reviews shown in UI
  List<HotelReviewUiModel> _displayReviews = [];
  HotelModel? _hotel;

  @override
  void initState() {
    super.initState();
    _filteredRoomTypes = List.from(_roomTypes);
    _minPriceController.text = _priceRange.start.round().toString();
    _maxPriceController.text = _priceRange.end.round().toString();
    _loadData();
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
      _filteredRoomTypes = _roomTypes.where((room) {
        final nameMatches = room.roomTypeName.toLowerCase().contains(
          query.toLowerCase(),
        );
        final idMatches = (room.id ?? '').toLowerCase().contains(
          query.toLowerCase(),
        );
        final priceMatches =
            room.pricePerNight >= _priceRange.start &&
            room.pricePerNight <= _priceRange.end;
        final ratingMatches = true;
        final amenitiesMatch = _selectedAmenities.every(
          (amenityId) => room.amensIds.contains(amenityId),
        );
        return (nameMatches || idMatches) &&
            priceMatches &&
            ratingMatches &&
            amenitiesMatch;
      }).toList();
      _sortRooms();
    });
  }

  void _sortRooms() {
    setState(() {
      if (_sortOrder == 'price_asc') {
        _filteredRoomTypes.sort(
          (a, b) => a.pricePerNight.compareTo(b.pricePerNight),
        );
      } else if (_sortOrder == 'price_desc') {
        _filteredRoomTypes.sort(
          (a, b) => b.pricePerNight.compareTo(a.pricePerNight),
        );
      } else if (_sortOrder == 'popularity') {
        _filteredRoomTypes.sort(
          (a, b) => a.roomTypeName.compareTo(b.roomTypeName),
        );
      }
    });
  }

  String _formatRelative(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds} giây trước';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  Future<void> _loadData() async {
    await _roomTypeController.loadRooms();
    await _amenityController.loadAmenities();
    await _hotelController.getAll();
    await _danhGiaController.getAll();

    if (!mounted) return;

    setState(() {
      _roomTypes = List.from(_roomTypeController.rooms);
      _filteredRoomTypes = List.from(_roomTypes);
      _amenities = List.from(_amenityController.amenities);
      _hotel = _hotelController.hotels.isNotEmpty
          ? _hotelController.hotels.first
          : null;
      _displayReviews = _danhGiaController.reviews
          .map(
            (review) => HotelReviewUiModel(
              reviewerName: review.userName ?? 'Khách hàng',
              reviewTimeText: _formatRelative(review.createdAt),
              content: review.content,
            ),
          )
          .toList();
    });
  }

  Widget _buildHeaderImage(String? imagePath) {
    final image = imagePath?.isNotEmpty == true
        ? imagePath!
        : 'assets/images/banner.jpg';
    final isNetworkUrl =
        image.startsWith('http://') || image.startsWith('https://');

    if (isNetworkUrl) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: _mainColor),
      );
    } else {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: _mainColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotel = _hotel;
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
              title: Text(
                hotel?.hotelName ?? 'Khách sạn Sun Hill Vũng Tàu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: _buildHeaderImage(hotel?.image),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final room = _filteredRoomTypes[index];
              return RoomTypeCard(
                room: room,
                amensList: _amenities,
                onTap: () => _openRoomDetail(context, room),
              );
            }, childCount: _filteredRoomTypes.length),
          ),
        ],
      ),
    );
  }

  void _openRoomDetail(BuildContext context, RoomTypeModel room) {
    final roomPayload = <String, dynamic>{
      'id': room.id ?? '',
      'name': room.roomTypeName,
      'price': room.pricePerNight,
      'amenities': _amenities
          .where((amenity) => room.amensIds.contains(amenity.id))
          .map((amenity) => amenity.amenityName)
          .toList(),
    };

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChiTietPhongScreen(
          roomType: _roomTypes.firstWhere((r) => r.id == room.id),
          amenities:  _amenities
          .where((amenity) => room.amensIds.contains(amenity.id))
          .map((amenity) => amenity)
          .toList(),
        ),
      ),
    );
  }

  Widget _buildHotelInfo() {
    final hotel = _hotel;
    final ratingText = hotel?.averageRating != null
        ? '${hotel!.averageRating!.toStringAsFixed(1)}/5'
        : 'Unknown';
    final addressText = hotel?.address ?? 'Unknown';
    final cityText = hotel?.city ?? 'Unknown';
    final descriptionText =
        hotel?.description ?? 'Unknown';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;

        final infoBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotel?.hotelName ?? 'Thông tin khách sạn',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _mainColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            _buildInfoRow(
              Icons.shopping_bag_outlined,
              addressText,
              color: _mainColor,
            ),
            const SizedBox(height: 4),
            _buildInfoRow(
              Icons.gamepad_outlined,
              '$cityText · $descriptionText',
              color: _mainColor,
            ),
          ],
        );

        final mapButton = TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => Map()),
            );
          },
          icon: Icon(Icons.map_outlined, color: _mainColor, size: 18),
          label: Text('Bản đồ', style: TextStyle(color: _mainColor)),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          ratingText,
                          style: TextStyle(
                            color: _mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Xuất sắc',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: _mainColor,
                          ),
                        ),
                        const Text(
                          'Đánh giá khách hàng',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: infoBlock),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: mapButton,
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    ratingText,
                    style: TextStyle(
                      color: _mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Xuất sắc',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: _mainColor,
                    ),
                  ),
                  const Text(
                    'Đánh giá khách hàng',
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: infoBlock),
            mapButton,
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
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
            Text(
              'Đánh giá (${_displayReviews.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            itemCount: _displayReviews.length,
            itemBuilder: (context, index) {
              return _buildReviewCardFromModel(_displayReviews[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCardFromModel(HotelReviewUiModel review) {
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
                    review.reviewerName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        review.reviewTimeText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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
              review.content,
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
            color: Colors.white,
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
                        decoration: const InputDecoration(
                          labelText: 'Giá thấp nhất',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
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
                        decoration: const InputDecoration(
                          labelText: 'Giá cao nhất',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập giá';
                          }
                          final maxPrice = int.tryParse(value);
                          if (maxPrice == null) {
                            return 'Giá không hợp lệ';
                          }
                          final minPrice = int.tryParse(
                            _minPriceController.text,
                          );
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
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const Text('Tiện ích'),
                      if (_amenities.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Chưa có dữ liệu tiện ích từ Firestore'),
                        )
                      else
                        ..._amenities.map((amenity) {
                          return CheckboxListTile(
                            title: Text(amenity.amenityName),
                            value: _selectedAmenities.contains(amenity.id),
                            activeColor: _mainColor,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true && amenity.id != null) {
                                  _selectedAmenities.add(amenity.id!);
                                } else {
                                  _selectedAmenities.remove(amenity.id);
                                }
                              });
                            },
                          );
                        }),
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
