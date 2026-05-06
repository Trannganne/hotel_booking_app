import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';

class ThemPhongScreen extends StatefulWidget {
  const ThemPhongScreen({Key? key}) : super(key: key);

  @override
  State<ThemPhongScreen> createState() => _ThemPhongScreenState();
}

class _ThemPhongScreenState extends State<ThemPhongScreen> {
  String? _loaiPhong = 'Deluxe';
  String? _soLuongKhach = '4';
  bool _isHoanTien = true;
  bool _isDoiLich = false;

  final TextEditingController _tenPhongController = TextEditingController(
    text: '301',
  );
  final TextEditingController _giaPhongController = TextEditingController(
    text: '350.000',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Màu nền tổng thể
      appBar: const CustomAppBar(title: "QUẢN LÝ PHÒNG"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THÊM PHÒNG MỚI',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Box tải ảnh (Dùng Container viền xám giả lập nét đứt)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
              ),
              child: const Center(
                child: Text(
                  '+ TẢI LÊN ẢNH PHÒNG',
                  style: TextStyle(
                    color: Color(0xFF289CF2),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form nhập liệu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownRow(
                    'Loại Phòng:',
                    ['Deluxe', 'Suite', 'Standard', 'Family'],
                    _loaiPhong,
                    (val) {
                      setState(() => _loaiPhong = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextFieldRow('Tên Phòng:', _tenPhongController),
                  const SizedBox(height: 16),

                  _buildDropdownRow(
                    'Số Lượng Khách:',
                    ['1', '2', '3', '4', '5'],
                    _soLuongKhach,
                    (val) {
                      setState(() => _soLuongKhach = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Tiện Ích
                  const Text(
                    'Tiện Ích',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  _buildAmenitiesGrid(),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Tầm Nhìn
                  const Text(
                    'Tầm Nhìn/ Quang Cảnh',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip('Quang cảnh núi'),
                      const SizedBox(width: 12),
                      _buildChip('Thành phố'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Chính Sách
                  const Text(
                    'Chính Sách',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPolicySwitch(
                          'Hoàn tiền',
                          _isHoanTien,
                          (val) => setState(() => _isHoanTien = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPolicySwitch(
                          'Đổi lịch',
                          _isDoiLich,
                          (val) => setState(() => _isDoiLich = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Giá Phòng
                  _buildTextFieldRow(
                    'Giá Phòng(VND)',
                    _giaPhongController,
                    showDropdownIcon: true,
                  ),
                  const SizedBox(height: 32),

                  // Nút Xác nhận
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF4DB6F5,
                        ), // Xanh nhạt hơn
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Lấy dữ liệu và gọi API lưu DB
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đang lưu thông tin phòng...'),
                          ),
                        );
                      },
                      child: const Text(
                        'XÁC NHẬN THÊM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Row cho Text Field
  Widget _buildTextFieldRow(
    String label,
    TextEditingController controller, {
    bool showDropdownIcon = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                suffixIcon: showDropdownIcon
                    ? const Icon(Icons.keyboard_arrow_down, color: Colors.black)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget Row cho Dropdown
  Widget _buildDropdownRow(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Center(child: Text(item)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget Tiện ích
  Widget _buildAmenitiesGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildAmenityItem(Icons.wifi, 'Wi-Fi miễn phí'),
            _buildAmenityItem(Icons.smoke_free, 'Không hút thuốc'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildAmenityItem(Icons.restaurant_menu, 'Không gồm bữa sáng'),
            _buildAmenityItem(Icons.king_bed_outlined, '1 giường cỡ queen'),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Chip Tầm nhìn
  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.landscape, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // Widget Switch Chính sách
  Widget _buildPolicySwitch(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.blue,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey,
        ),
      ],
    );
  }
}
