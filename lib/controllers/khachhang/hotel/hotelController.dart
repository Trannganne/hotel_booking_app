import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/HotelModel.dart';
import 'package:hotel_booking_app/services/hotel_service/hotel_service.dart';

class HotelController extends ChangeNotifier {
  final HotelService _service = HotelService();

  List<HotelModel> hotels = [];
  bool isLoading = false;

  Future<List<HotelModel>> getAll() async {
    try {
      isLoading = true;
      notifyListeners();

      hotels = await _service.getAll();
    } catch (e) {
      debugPrint("Lỗi load amenities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return hotels;
  }
}
