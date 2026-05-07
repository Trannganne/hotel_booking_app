import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';

class ChinhSuaPhongScreen extends StatefulWidget {
  const ChinhSuaPhongScreen({Key? key}) : super(key: key);

  @override
  State<ChinhSuaPhongScreen> createState() => _ChinhSuaPhongScreenState();
}

class _ChinhSuaPhongScreenState extends State<ChinhSuaPhongScreen> {
  // Các biến lưu trạng thái của form
  String _loaiPhong = 'Suite';
  String _dienTich = '20';
  String _nguoiPhong = '2';
  String _giuongPhong = '1';
  bool _gomBuaSang = true;
  bool _khongHutThuoc = true;
  bool _hoanTien = true;
  bool _doiLich = false;
  String _tamNhin = 'Quang cảnh núi';

  // Controllers cho các ô nhập liệu
  final TextEditingController _tenPhongController = TextEditingController(
    text: 'Suite Có Tầm Nhìn Ra Núi',
  );
  final TextEditingController _tienNghiController = TextEditingController(
    text: '. Máy lạnh\n. Nước đóng chai miễn phí\n. TV\n. Bàn làm việc',
  );
  final TextEditingController _phongTamController = TextEditingController(
    text:
        '. Nước nóng\n. Phòng tắm riêng\n. Vòi tắm đứng\n. Bộ vệ sinh cá nhân\n. Áo choàng tắm\n. Máy sấy tóc',
  );

  // Các biến cho phần giá
  String _giaMotDem = '328.734';
  String _thue = '50.955';
  final TextEditingController _giaTongController = TextEditingController(
    text: '379.689',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: const CustomAppBar(title: "Chỉnh sửa thông tin phòng"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. ẢNH PHÒNG VÀ NÚT CẬP NHẬT ---
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://via.placeholder.com/600x300', // Thay bằng ảnh thật
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Lớp phủ đen mờ
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                // Icon máy ảnh
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        // TODO: Gọi hàm chọn ảnh từ thư viện
                      },
                    ),
                    const Text(
                      'Cập nhật ảnh',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // --- 2. FORM NHẬP LIỆU ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên phòng
                  _buildLabel('Tên phòng'),
                  const SizedBox(height: 4),
                  _buildTextField(_tenPhongController),
                  const SizedBox(height: 12),

                  // Loại phòng & Diện tích
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Loại Phòng'),
                            const SizedBox(height: 4),
                            _buildDropdown(
                              ['Suite', 'Deluxe', 'Standard'],
                              _loaiPhong,
                              (v) => setState(() => _loaiPhong = v!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Diện tích'),
                            const SizedBox(height: 4),
                            _buildDropdown(
                              ['20', '25', '30'],
                              _dienTich,
                              (v) => setState(() => _dienTich = v!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Người/phòng & Giường/phòng
                  Row(
                    children: [
                      Expanded(
                        child: _buildIconLabelRow(Icons.person, 'Người/phòng'),
                      ),
                      Expanded(
                        child: _buildDropdown(
                          ['1', '2', '3', '4'],
                          _nguoiPhong,
                          (v) => setState(() => _nguoiPhong = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIconLabelRow(
                          Icons.king_bed,
                          'Giường/phòng',
                        ),
                      ),
                      Expanded(
                        child: _buildDropdown(
                          ['1', '2', '3'],
                          _giuongPhong,
                          (v) => setState(() => _giuongPhong = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Switch: Bữa sáng & Hút thuốc
                  Row(
                    children: [
                      Expanded(
                        child: _buildIconLabelRow(
                          Icons.restaurant,
                          'Gồm bữa sáng',
                        ),
                      ),
                      Expanded(
                        child: _buildSwitch(
                          _gomBuaSang,
                          (v) => setState(() => _gomBuaSang = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIconLabelRow(
                          Icons.smoke_free,
                          'Không hút thuốc',
                        ),
                      ),
                      Expanded(
                        child: _buildSwitch(
                          _khongHutThuoc,
                          (v) => setState(() => _khongHutThuoc = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tầm nhìn
                  _buildLabel('Tầm nhìn'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChoiceChip('Quang cảnh núi'),
                      _buildChoiceChip('Quang cảnh biển'),
                      _buildChoiceChip('Quang cảnh thành phố'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Chính sách hủy phòng
                  _buildLabel('Chính sách hủy phòng'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPolicySwitch(
                          'Hoàn tiền',
                          _hoanTien,
                          (v) => setState(() => _hoanTien = v),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPolicySwitch(
                          'Đổi lịch',
                          _doiLich,
                          (v) => setState(() => _doiLich = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đặt phòng này có thể hoàn tiền và không thể đổi lịch',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Phòng tiện nghi
                  _buildLabel('Phòng tiện nghi'),
                  const SizedBox(height: 4),
                  _buildMultiLineTextField(_tienNghiController),
                  const SizedBox(height: 16),

                  // Trang bị phòng tắm
                  _buildLabel('Trang bị phòng tắm'),
                  const SizedBox(height: 4),
                  _buildMultiLineTextField(_phongTamController),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Phần giá
                  _buildPriceRow(
                    'Giá một đêm(VND)',
                    _buildDropdown(
                      ['328.734', '400.000'],
                      _giaMotDem,
                      (v) => setState(() => _giaMotDem = v!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Thuế(VND)',
                    _buildDropdown(
                      ['50.955', '60.000'],
                      _thue,
                      (v) => setState(() => _thue = v!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Giá tổng(VND)',
                    Container(
                      height: 35,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _giaTongController.text,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nút Lưu và Hủy
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4DB6F5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Xử lý lưu
                          },
                          child: const Text(
                            'Lưu thay đổi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Hủy',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CÁC HÀM TIỆN ÍCH BUILD GIAO DIỆN ---

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return SizedBox(
      height: 35,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiLineTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 5,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: const TextStyle(fontSize: 13, color: Colors.black),
          items: items
              .map(
                (String item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildIconLabelRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Transform.scale(
        scale: 0.8, // Thu nhỏ switch lại một chút cho vừa mắt
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF289CF2),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    final isSelected = _tamNhin == label;
    return InkWell(
      onTap: () => setState(() => _tamNhin = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF289CF2) : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? const Color(0xFF289CF2) : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySwitch(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 4),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF289CF2),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, Widget inputWidget) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Expanded(flex: 1, child: inputWidget),
      ],
    );
  }
}
