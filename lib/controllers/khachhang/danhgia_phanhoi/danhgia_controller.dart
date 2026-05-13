// controllers/danhgia_controller.dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/services/roomType_service/roomType_Service.dart';
import '../../../models/BaseModel/ReviewModel.dart';
import '../../../services/cloudinary_service/cloudinary_service.dart';
import '../../../services/review_service/reviewService.dart';

class ReviewController extends ChangeNotifier {
  final CloudinaryService _cloudinary = CloudinaryService();
  final Reviewservice reviewService = Reviewservice();
  final RoomTypeService _roomTypeService = RoomTypeService();

  List<ReviewModel> reviews = [];
  bool isLoading = false;

  Future<void> submitReview(ReviewModel review, List<File> images) async {
    try {
      List<String> imageUrls = [];

      // upload ảnh
      imageUrls = await _cloudinary.uploadMultipleImages(images);
      review.images = imageUrls;

      await reviewService.addReview(review);
    } catch (e) {
      debugPrint("Lỗi thêm đánh giá: $e");
    }
  }

  Future<RoomTypeModel?> getRoomType(String roomTypeId) async {
    return await _roomTypeService.getByID(roomTypeId);
  }

  Future<void> getAll() async {
    try {
      isLoading = true;
      notifyListeners();

      reviews = await reviewService.getAll();
    } catch (e) {
      debugPrint("Lỗi load amenities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateReviewReply(String reviewId, String adminReply) async {
    try {
      await reviewService.updateReviewReply(reviewId, adminReply);
      final index = reviews.indexWhere((element) => element.id == reviewId);
      if (index >= 0) {
        reviews[index].adminReply = adminReply;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Lỗi cập nhật phản hồi: $e");
    }
  }
}
