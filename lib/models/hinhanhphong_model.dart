// models/hinh_anh_phong.dart
class HinhAnhPhong {
  int? maHinhAnh;
  int maLoaiPhong;
  String duongDanAnh;
  bool laAnhChinh;

  HinhAnhPhong({
    this.maHinhAnh,
    required this.maLoaiPhong,
    required this.duongDanAnh,
    this.laAnhChinh = false,
  });
}
