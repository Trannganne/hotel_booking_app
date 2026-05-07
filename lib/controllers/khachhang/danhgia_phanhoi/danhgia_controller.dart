// controllers/danhgia_controller.dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import '../../../models/BaseModel/ReviewModel.dart';
import '../../../services/cloudinary_service/cloudinary_service.dart';
import '../../../services/danhgia_service/danhgia_service.dart';

class ReviewController {
  final CloudinaryService _cloudinary = CloudinaryService();
  final DanhGiaService danhGiaService = DanhGiaService();

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
}
