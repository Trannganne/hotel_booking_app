import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/room/roomController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:provider/provider.dart';

class ChinhSuaPhongScreen extends StatefulWidget {
  final RoomModel room;

  const ChinhSuaPhongScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<ChinhSuaPhongScreen> createState() => _ChinhSuaPhongScreenState();
}

class _ChinhSuaPhongScreenState extends State<ChinhSuaPhongScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _soPhongController;
  late final TextEditingController _tangController;

  String? _selectedRoomTypeId;
  late RoomStatus _selectedStatus;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _soPhongController = TextEditingController(text: widget.room.roomNumber);
    _tangController = TextEditingController(text: widget.room.floor.toString());

    _selectedRoomTypeId = widget.room.roomTypeId;
    _selectedStatus = widget.room.status;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final roomTypeController = context.read<RoomTypeController>();

      if (roomTypeController.rooms.isEmpty) {
        await roomTypeController.loadRooms();
      }

      if (!mounted) return;
      setState(() {});
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

    if (widget.room.id == null || widget.room.id!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không tìm thấy ID phòng')));
      return;
    }

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

    final success = await context
        .read<RoomController>()
        .updateRoom(widget.room.id!, {
          'roomNumber': _soPhongController.text.trim(),
          'floor': floor,
          'roomTypeId': _selectedRoomTypeId,
          'status': _selectedStatus.name,
          'isDeleted': false,
        });

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật phòng thành công')),
      );

      Navigator.pop(context, true);
    } else {
      final error = context.read<RoomController>().errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Cập nhật phòng thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomTypeController = context.watch<RoomTypeController>();
    final roomTypes = roomTypeController.rooms;

    final hasSelectedRoomType = roomTypes.any(
      (roomType) => roomType.id == _selectedRoomTypeId,
    );

    final dropdownValue = hasSelectedRoomType ? _selectedRoomTypeId : null;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9),
      appBar: const CustomAppBar(title: 'CHỈNH SỬA PHÒNG'),
      body: roomTypeController.isLoading && roomTypes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHỈNH SỬA PHÒNG ${widget.room.roomNumber}',
                      style: const TextStyle(
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

                          _buildRoomTypeDropdown(
                            roomTypes: roomTypes,
                            dropdownValue: dropdownValue,
                          ),

                          const SizedBox(height: 16),

                          _buildStatusDropdown(),

                          const SizedBox(height: 28),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
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
                                            'LƯU THAY ĐỔI',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 46,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: _isSaving
                                        ? null
                                        : () => Navigator.pop(context),
                                    child: Text(
                                      'HỦY',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
        'Màn này chỉ chỉnh sửa phòng cụ thể. Giá, ảnh, tiện ích và mô tả thuộc loại phòng.',
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

  Widget _buildRoomTypeDropdown({
    required List<RoomTypeModel> roomTypes,
    required String? dropdownValue,
  }) {
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
                value: dropdownValue,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: const Text('Chọn loại phòng'),
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
          'Trạng thái:',
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
