import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/room/roomController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:provider/provider.dart';

class ThemPhongScreen extends StatefulWidget {
  const ThemPhongScreen({Key? key}) : super(key: key);

  @override
  State<ThemPhongScreen> createState() => _ThemPhongScreenState();
}

class _ThemPhongScreenState extends State<ThemPhongScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _soPhongController = TextEditingController();
  final TextEditingController _tangController = TextEditingController();

  String? _selectedRoomTypeId;
  RoomStatus _selectedStatus = RoomStatus.available;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final roomTypeController = context.read<RoomTypeController>();

      if (roomTypeController.rooms.isEmpty) {
        await roomTypeController.loadRooms();
      }

      if (!mounted) return;

      if (roomTypeController.rooms.isNotEmpty && _selectedRoomTypeId == null) {
        setState(() {
          _selectedRoomTypeId = roomTypeController.rooms.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _soPhongController.dispose();
    _tangController.dispose();
    super.dispose();
  }

  String _statusText(RoomStatus status) {
    switch (status) {
      case RoomStatus.available:
        return 'Trống';
      case RoomStatus.cleaning:
        return 'Đang dọn';
      case RoomStatus.maintenance:
        return 'Bảo trì';
      case RoomStatus.locked:
        return 'Khóa';
    }
  }

  Future<void> _saveRoom() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_selectedRoomTypeId == null || _selectedRoomTypeId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng chọn loại phòng')));
      return;
    }

    final floor = int.tryParse(_tangController.text.trim());

    if (floor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tầng phải là số hợp lệ')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final room = RoomModel(
      roomTypeId: _selectedRoomTypeId!,
      roomNumber: _soPhongController.text.trim(),
      floor: floor,
      status: _selectedStatus,
      isDeleted: false,
    );

    final success = await context.read<RoomController>().addRoom(room);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Thêm phòng thành công')));

      Navigator.pop(context, true);
    } else {
      final error = context.read<RoomController>().errorMessage;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? 'Thêm phòng thất bại')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomTypeController = context.watch<RoomTypeController>();
    final roomTypes = roomTypeController.rooms;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9),
      appBar: const CustomAppBar(title: 'THÊM PHÒNG'),
      body: roomTypeController.isLoading && roomTypes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'THÊM PHÒNG MỚI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildInfoBox(),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextFieldRow(
                            label: 'Số phòng:',
                            controller: _soPhongController,
                            hintText: 'Ví dụ: 101',
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập số phòng';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          _buildTextFieldRow(
                            label: 'Tầng:',
                            controller: _tangController,
                            hintText: 'Ví dụ: 1',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập tầng';
                              }

                              if (int.tryParse(value.trim()) == null) {
                                return 'Tầng phải là số';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          _buildRoomTypeDropdown(roomTypes),

                          const SizedBox(height: 16),

                          _buildStatusDropdown(),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4DB6F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _isSaving ? null : _saveRoom,
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
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
            ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: const Text(
        'Phòng cụ thể sẽ dùng thông tin giá, ảnh, tiện ích từ loại phòng đã chọn.',
        style: TextStyle(fontSize: 13, color: Color(0xFF1565C0), height: 1.4),
      ),
    );
  }

  Widget _buildTextFieldRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomTypeDropdown(List<RoomTypeModel> roomTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại phòng:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        if (roomTypes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Text(
              'Chưa có loại phòng. Vui lòng tạo loại phòng trước.',
              style: TextStyle(color: Colors.red),
            ),
          )
        else
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRoomTypeId,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: roomTypes.map((roomType) {
                  return DropdownMenuItem<String>(
                    value: roomType.id,
                    child: Text(roomType.roomTypeName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoomTypeId = value;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trạng thái ban đầu:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoomStatus>(
              value: _selectedStatus,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: RoomStatus.values.map((status) {
                return DropdownMenuItem<RoomStatus>(
                  value: status,
                  child: Text(_statusText(status)),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
