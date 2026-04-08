// models/danh_gia.dart
class DanhGia {
  int? maDanhGia;
  int maDatPhong;
  int maTaiKhoan;
  int soSao;
  String noiDung;
  DateTime? ngayTao;

  DanhGia({
    this.maDanhGia,
    required this.maDatPhong,
    required this.maTaiKhoan,
    required this.soSao,
    required this.noiDung,
    this.ngayTao,
  });
}
