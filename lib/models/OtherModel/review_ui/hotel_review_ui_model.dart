/// Dữ liệu đánh giá hiển thị ở màn chi tiết khách sạn.
class HotelReviewUiModel {
  final String reviewerName;
  final String reviewTimeText;
  final String content;
  final String? replyAdmin;

  const HotelReviewUiModel({
    required this.reviewerName,
    required this.reviewTimeText,
    required this.content,
    this.replyAdmin,
  });
}
