// models/phan_phong.dart
class PhanPhong {
  int? maPhanPhong;
  int maDatPhong;
  int maPhong;
  DateTime ngayNhan;
  DateTime ngayTra;

  PhanPhong({
    this.maPhanPhong,
    required this.maDatPhong,
    required this.maPhong,
    required this.ngayNhan,
    required this.ngayTra,
  });
}
