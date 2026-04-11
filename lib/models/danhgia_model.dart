// models/danh_gia.dart
class DanhGia {
  int? maDanhGia;
  int maDatPhong;
  int maTaiKhoan;
  int soSao;
  String noiDung;
  DateTime? ngayTao;
  List<String>? danhSachAnh; // Thêm trường để lưu danh sách hình ảnh đánh giá

  String? phanHoiAdmin; // Để lưu nội dung Admin trả lời
  String? tenNguoiDung;
  String? avatar;

  DanhGia({
    this.maDanhGia,
    required this.maDatPhong,
    required this.maTaiKhoan,
    required this.soSao,
    required this.noiDung,
    this.danhSachAnh,
    this.ngayTao,
    this.phanHoiAdmin,
    this.tenNguoiDung,
    this.avatar,
  });
}
