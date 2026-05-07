import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class QLDonDatPhongScreen extends StatefulWidget {
  const QLDonDatPhongScreen({super.key});

  @override
  State<QLDonDatPhongScreen> createState() => _QLDonDatPhongScreenState();
}

class _QLDonDatPhongScreenState extends State<QLDonDatPhongScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn đặt phòng',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0077FF),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chờ thanh toán'),
            Tab(text: 'Đang chờ duyệt'),
            Tab(text: 'Đã đặt'),
            Tab(text: 'Đã nhận phòng'),
            Tab(text: 'Đã hủy'),
            Tab(text: 'Hoàn tất'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList('Tất cả'),
          _buildBookingList('Chờ thanh toán'),
          _buildBookingList('Đang chờ duyệt'),
          _buildBookingList('Đã đặt'),
          _buildBookingList('Đã nhận phòng'),
          _buildBookingList('Đã hủy'),
          _buildBookingList('Hoàn tất'),
        ],
      ),
    );
  }

  Widget _buildBookingList(String status) {
    // This is a placeholder. In a real app, you would filter bookings based on the status.
    final images = [
      'phong01_01.jpg',
      'phong02_01.jpg',
      'phong01_02.jpg',
      'phong02_02.jpg',
      'phong01_03.jpg',
    ];
    return ListView.builder(
      itemCount: 5, // Placeholder for number of bookings
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.all(8.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChiTietDonDatPhongScreen(
                    image: 'assets/images/${images[index % images.length]}',
                  ),
                ),
              );
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/${images[index % images.length]}', // Use available images
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phòng ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ), // Placeholder
                          const SizedBox(height: 4),
                          Text('Mã phòng: P00${index + 1}'),
                          Text('Khách hàng: Nguyễn Văn A'),
                          Text('SĐT: 0123456789'),
                          const Spacer(),
                          if (status != 'Tất cả')
                            badges.Badge(
                              badgeContent: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              badgeStyle: badges.BadgeStyle(
                                shape: badges.BadgeShape.square,
                                badgeColor: _getStatusColor(status),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Chờ thanh toán':
        return Colors.orange;
      case 'Đang chờ duyệt':
        return Colors.blue;
      case 'Đã đặt':
        return Colors.green;
      case 'Đã nhận phòng':
        return Colors.purple;
      case 'Đã hủy':
        return Colors.red;
      case 'Hoàn tất':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}

class ChiTietDonDatPhongScreen extends StatefulWidget {
  final String image;
  const ChiTietDonDatPhongScreen({super.key, required this.image});

  @override
  _ChiTietDonDatPhongScreenState createState() =>
      _ChiTietDonDatPhongScreenState();
}

class _ChiTietDonDatPhongScreenState extends State<ChiTietDonDatPhongScreen> {
  String _selectedStatus = 'Đã nhận phòng';
  bool _isCancelled = false;

  final List<String> _statuses = ['Đã nhận phòng', 'Đã hủy', 'Hoàn tất'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn đặt phòng',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0077FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                widget.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Thông tin phòng'),
            _buildInfoRow('Mã phòng:', 'P001'),
            _buildInfoRow('Tên phòng:', 'Phòng Deluxe'),
            _buildInfoRow('Giá phòng:', '1.500.000 VNĐ/đêm'),
            _buildInfoRow('Tiện ích:', 'Wifi, TV, Điều hòa, Nóng lạnh'),
            _buildInfoRow('Mô tả:', 'Phòng rộng rãi, thoáng mát với view đẹp.'),
            const SizedBox(height: 20),
            _buildSectionTitle('Thông tin khách đặt'),
            _buildInfoRow('Họ tên:', 'Nguyễn Văn A'),
            _buildInfoRow('Số điện thoại:', '0123456789'),
            const SizedBox(height: 20),
            _buildSectionTitle('Thông tin đơn'),
            _buildInfoRow('Số lượng người ở:', '2'),
            Row(
              children: [
                const Text('Trạng thái đơn: '),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        items: _statuses.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: _isCancelled
                            ? null
                            : (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedStatus = newValue;
                                    if (newValue == 'Đã hủy') {
                                      _isCancelled = true;
                                    }
                                  });
                                }
                              },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isCancelled
                    ? null
                    : () {
                        // Handle status update logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cập nhật trạng thái thành công!'),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077FF),
                ),
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
