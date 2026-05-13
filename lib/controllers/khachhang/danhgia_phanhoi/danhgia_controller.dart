// controllers/danhgia_controller.dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import '../../../models/BaseModel/ReviewModel.dart';
import '../../../services/cloudinary_service/cloudinary_service.dart';
import '../../../services/danhgia_service/danhgia_service.dart';

class ReviewController extends ChangeNotifier {
  final CloudinaryService _cloudinary = CloudinaryService();
  final DanhGiaService danhGiaService = DanhGiaService();

  List<ReviewModel> reviews = [];
  bool isLoading = false;

  Future<void> submitDanhGia(ReviewModel review, List<File> images) async {
    try {
      List<String> imageUrls = [];

      // upload ảnh
      imageUrls = await _cloudinary.uploadMultipleImages(images);
      review.images = imageUrls;

      await danhGiaService.addDanhGia(review);
    } catch (e) {
      debugPrint("Lỗi thêm đánh giá: $e");
    }
  }

    Future<void> getAll() async {
    try {
      isLoading = true;
      notifyListeners();

      reviews = await danhGiaService.getAll();
    } catch (e) {
      debugPrint("Lỗi load amenities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
