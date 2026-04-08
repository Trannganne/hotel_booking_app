// models/so_luong_phong.dart
class SoLuongPhong {
  int? maSoLuong;
  int maLoaiPhong;
  DateTime ngay;
  double gia;
  int soPhongCon;

  SoLuongPhong({
    this.maSoLuong,
    required this.maLoaiPhong,
    required this.ngay,
    required this.gia,
    required this.soPhongCon,
  });
}
