// models/phong.dart
class Phong {
  int? maPhong;
  int maLoaiPhong;
  String soPhong;
  int tang;
  String trangThai; // TRONG / DANG_SU_DUNG / BAO_TRI / DANG_DON_DEP

  Phong({
    this.maPhong,
    required this.maLoaiPhong,
    required this.soPhong,
    required this.tang,
    required this.trangThai,
  });
}
