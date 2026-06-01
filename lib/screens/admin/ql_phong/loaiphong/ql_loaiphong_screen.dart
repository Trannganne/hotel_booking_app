import 'package:intl/intl.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/controllers/admin/amenity/amenityController.dart';
import 'package:hotel_booking_app/controllers/admin/policy/policyController.dart';
import 'package:hotel_booking_app/controllers/admin/ql_phong/roomType/roomtypeController.dart';
import 'package:hotel_booking_app/core/widgets/ImagePickerWidget/ImagePickerWidget.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/core/widgets/roomType/roomTypeCard.dart';
import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
// import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
import 'package:provider/provider.dart';

class RoomTypeScreen extends StatefulWidget {
  const RoomTypeScreen({super.key});

  @override
  State<RoomTypeScreen> createState() => _RoomTypeScreenState();
}

class _RoomTypeScreenState extends State<RoomTypeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<RoomTypeController>().loadRooms();

    await context.read<AmenityController>().loadAmenities();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RoomTypeController>();
    final amensController = context.watch<AmenityController>();

    return Scaffold(
      appBar: const CustomAppBar(title: "Quản lý loại phòng"),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm loại phòng...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    controller.search(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // LIST
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: controller.loadRooms,
                    child: ListView.builder(
                      itemCount: controller.rooms.length,
                      itemBuilder: (context, index) {
                        final room = controller.rooms[index];

                        return RoomTypeCard(
                          roomType: room,
                          amensList: amensController.amenities,
                          onDetail: () {
                            _showDetailDialog(context, room);
                          },
                          onEdit: () {
                            _showEditDialog(context, room);
                          },
                          onDelete: () {
                            _confirmDeleteRoomType(context, room);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ================= ADD DIALOG =================
  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final guestController = TextEditingController();
    final areaController = TextEditingController();
    final bedController = TextEditingController();
    final bedCountController = TextEditingController();
    final descriptionController = TextEditingController();

    // Policy
    bool breakfastIncluded = false;
    bool isRefundable = false;
    bool canReschedule = false;

    // View
    String selectedView = "Biển";
    List<String> selectedUtils = [];
    List<File> selectedImages = [];

    final views = ["Biển", "Núi rừng", "Hồ bơi", "Thành phố"];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final amens = context.watch<AmenityController>().amenities;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text("Thêm loại phòng"),

              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _input(nameController, "Tên loại phòng"),
                      _input(priceController, "Giá", number: true),
                      _input(areaController, "Diện tích", number: true),
                      _input(bedController, "Loại giường"),
                      _input(bedCountController, "Số giường", number: true),
                      _input(guestController, "Số khách", number: true),

                      const SizedBox(height: 10),

                      // HƯỚNG PHÒNG
                      DropdownButtonFormField(
                        value: selectedView,
                        decoration: const InputDecoration(
                          labelText: "Hướng phòng",
                          border: OutlineInputBorder(),
                        ),
                        items: views
                            .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() => selectedView = v!);
                        },
                      ),

                      const SizedBox(height: 10),

                      _input(descriptionController, "Mô tả", maxLines: 3),

                      const SizedBox(height: 10),

                      // TIỆN ÍCH
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tiện ích",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Wrap(
                        spacing: 8,
                        children: amens.map((u) {
                          final isSelected = selectedUtils.contains(u.id);

                          return FilterChip(
                            label: Text(u.amenityName),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  selectedUtils.remove(u.id);
                                } else {
                                  selectedUtils.add(u.id!);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 15),

                      ImagePickerWidget(
                        images: selectedImages,
                        onChanged: (images) {
                          Future.microtask(() {
                            setState(() {
                              selectedImages = List.from(images);
                            });
                          });
                        },
                      ),
                      // ================= POLICY =================
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Chính sách phòng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      //  Bữa sáng
                      CheckboxListTile(
                        title: const Text("Có bữa sáng"),
                        value: breakfastIncluded,
                        onChanged: (v) {
                          setState(() => breakfastIncluded = v ?? false);
                        },
                      ),

                      //  Cho phép hoàn tiền
                      CheckboxListTile(
                        title: const Text("Cho phép hoàn tiền"),
                        value: isRefundable,
                        onChanged: (v) {
                          setState(() => isRefundable = v ?? false);
                        },
                      ),

                      //  Cho phép đổi lịch
                      CheckboxListTile(
                        title: const Text("Cho phép đổi lịch"),
                        value: canReschedule,
                        onChanged: (v) {
                          setState(() => canReschedule = v ?? false);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final controller = context.read<RoomTypeController>();
                    final policyController = context.read<Policycontroller>();

                    // 1. TẠO POLICY TRƯỚC
                    final policyId = await policyController.addPolicy(
                      PolicyModel(
                        breakfastIncluded: breakfastIncluded,
                        isRefundable: isRefundable,
                        canReschedule: canReschedule,
                      ),
                    );

                    // 2. TẠO ROOMTYPE

                    final newRoom = RoomTypeModel(
                      roomTypeName: nameController.text,
                      pricePerNight: double.tryParse(priceController.text) ?? 0,
                      area: double.tryParse(areaController.text) ?? 20,
                      bedType: bedController.text,
                      bedCount: int.tryParse(bedCountController.text) ?? 1,
                      maxOccupancy: int.tryParse(guestController.text) ?? 2,
                      view: selectedView,
                      description: descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : "Phòng tiện nghi, phù hợp cho kỳ nghỉ thoải mái.",
                      policyId: policyId!,
                      amensIds: selectedUtils,
                      imagesList: [],
                    );

                    await controller.addRoomType(newRoom, selectedImages);

                    Navigator.pop(context);
                  },
                  child: const Text("Thêm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, RoomTypeModel room) {
    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final amens = context.read<AmenityController>().amenities;

    final selectedAmens = room.amensIds
        .map(
          (id) => amens.firstWhere(
            (a) => a.id == id,
            orElse: () =>
                Amenitymodel(id: '', amenityName: 'Không rõ', icon: 'default'),
          ),
        )
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    room.roomTypeName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (room.imagesList.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        room.imagesList.first,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image, size: 60),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  _detailRow(
                    'Giá mỗi đêm',
                    formatCurrency.format(room.pricePerNight),
                  ),
                  _detailRow('Diện tích', '${room.area.toStringAsFixed(0)} m²'),
                  _detailRow('Loại giường', room.bedType),
                  _detailRow('Số giường', room.bedCount.toString()),
                  _detailRow('Số khách tối đa', room.maxOccupancy.toString()),
                  _detailRow('Tầm nhìn', room.view),
                  _detailRow('Mô tả', room.description),

                  const SizedBox(height: 12),

                  const Text(
                    'Tiện ích',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  selectedAmens.isEmpty
                      ? const Text('Chưa có tiện ích')
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: selectedAmens.map((amen) {
                            return Chip(label: Text(amen.amenityName));
                          }).toList(),
                        ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng'),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, RoomTypeModel room) {
    final nameController = TextEditingController(text: room.roomTypeName);
    final priceController = TextEditingController(
      text: room.pricePerNight.toStringAsFixed(0),
    );
    final guestController = TextEditingController(
      text: room.maxOccupancy.toString(),
    );
    final areaController = TextEditingController(
      text: room.area.toStringAsFixed(0),
    );
    final bedController = TextEditingController(text: room.bedType);
    final bedCountController = TextEditingController(
      text: room.bedCount.toString(),
    );
    final descriptionController = TextEditingController(text: room.description);

    final views = ["Biển", "Núi rừng", "Hồ bơi", "Thành phố"];

    String selectedView = views.contains(room.view) ? room.view : views.first;
    List<String> selectedUtils = List<String>.from(room.amensIds);
    List<File> selectedImages = [];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final amens = context.watch<AmenityController>().amenities;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text("Sửa loại phòng"),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _input(nameController, "Tên loại phòng"),
                      _input(priceController, "Giá", number: true),
                      _input(areaController, "Diện tích", number: true),
                      _input(bedController, "Loại giường"),
                      _input(bedCountController, "Số giường", number: true),
                      _input(guestController, "Số khách", number: true),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: selectedView,
                        decoration: const InputDecoration(
                          labelText: "Hướng phòng",
                          border: OutlineInputBorder(),
                        ),
                        items: views.map((view) {
                          return DropdownMenuItem(
                            value: view,
                            child: Text(view),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => selectedView = value);
                        },
                      ),

                      const SizedBox(height: 10),

                      _input(descriptionController, "Mô tả", maxLines: 3),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tiện ích",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Wrap(
                        spacing: 8,
                        children: amens.map((amenity) {
                          final isSelected = selectedUtils.contains(amenity.id);

                          return FilterChip(
                            label: Text(amenity.amenityName),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                if (isSelected) {
                                  selectedUtils.remove(amenity.id);
                                } else {
                                  selectedUtils.add(amenity.id!);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 15),

                      if (room.imagesList.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Ảnh hiện tại",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: room.imagesList.length,
                                itemBuilder: (context, index) {
                                  final imageUrl = room.imagesList[index];

                                  return Container(
                                    width: 90,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return Container(
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.broken_image,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 15),

                      ImagePickerWidget(
                        images: selectedImages,
                        onChanged: (images) {
                          Future.microtask(() {
                            setState(() {
                              selectedImages = List.from(images);
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tên loại phòng không được để trống'),
                        ),
                      );
                      return;
                    }

                    final updatedRoom = RoomTypeModel(
                      id: room.id,
                      roomTypeName: nameController.text.trim(),
                      pricePerNight:
                          double.tryParse(priceController.text.trim()) ?? 0,
                      area: double.tryParse(areaController.text.trim()) ?? 0,
                      bedType: bedController.text.trim(),
                      bedCount:
                          int.tryParse(bedCountController.text.trim()) ?? 1,
                      maxOccupancy:
                          int.tryParse(guestController.text.trim()) ?? 1,
                      view: selectedView,
                      description: descriptionController.text.trim().isNotEmpty
                          ? descriptionController.text.trim()
                          : "Phòng tiện nghi, phù hợp cho kỳ nghỉ thoải mái.",
                      policyId: room.policyId,
                      amensIds: selectedUtils,
                      imagesList: List<String>.from(room.imagesList),
                    );

                    final success = await context
                        .read<RoomTypeController>()
                        .updateRoomType(updatedRoom, selectedImages);

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Cập nhật loại phòng thành công'
                              : 'Cập nhật loại phòng thất bại',
                        ),
                      ),
                    );
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteRoomType(
    BuildContext context,
    RoomTypeModel room,
  ) async {
    if (room.id == null || room.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy ID loại phòng')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Xóa loại phòng'),
          content: Text(
            'Bạn có chắc muốn xóa loại phòng "${room.roomTypeName}" không?\n\n'
            'Dữ liệu sẽ bị xóa khỏi collection room_types.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final success = await context.read<RoomTypeController>().deleteRoomType(
      room.id!,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Đã xóa loại phòng ${room.roomTypeName}'
              : 'Xóa loại phòng thất bại',
        ),
      ),
    );
  }

  // INPUT
  Widget _input(
    TextEditingController controller,
    String hint, {
    bool number = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
