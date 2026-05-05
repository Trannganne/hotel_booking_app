import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/services/amenity_service/amens_service.dart';

class AmenityController extends ChangeNotifier {
  final AmenityService _service = AmenityService();

  List<Amenitymodel> amenities = [];
  bool isLoading = false;

  // 🔹 Load tất cả tiện ích
  Future<void> loadAmenities() async {
    try {
      isLoading = true;
      notifyListeners();

      amenities = await _service.getAllUtils();
    } catch (e) {
      debugPrint("Lỗi load amenities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Lấy tiện ích theo danh sách ID
  Future<List<Amenitymodel>> getAmenitiesByIds(List<String> ids) async {
    try {
      return await _service.getAmenitiesByIds(ids);
    } catch (e) {
      debugPrint("Lỗi get amenities by ids: $e");
      return [];
    }
  }
}
