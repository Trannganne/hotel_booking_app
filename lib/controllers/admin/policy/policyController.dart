import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/PolicyModel.dart';
import 'package:hotel_booking_app/services/policy_service/policyService.dart';

class Policycontroller extends ChangeNotifier {
  final Policyservice _policyservice = Policyservice();

  List<PolicyModel> policies = [];
  bool isLoading = false;

  // Thêm chính sách
  Future<String?> addPolicy(PolicyModel policy) async {
    try {
      isLoading = true;
      notifyListeners();

      final id = await _policyservice.addPolicy(policy);
      await loadPolicies();
      return id;
    } catch (e) {
      debugPrint("Lỗi thêm roomtype: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load tất cả room type
  Future<void> loadPolicies() async {
    isLoading = true;
    notifyListeners();

    try {
      policies = await _policyservice.getAll();
    } catch (e) {
      debugPrint("Lỗi load policies: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
