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
import 'package:hotel_booking_app/models/BaseModel/UserModel.dart';
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
      appBar: const CustomAppBar(title: "Quản lý phòng"),

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
                          room: room,
                          amensList: amensController.amenities,
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
