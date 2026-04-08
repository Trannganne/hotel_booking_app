// models/khach_san.dart
class KhachSan {
  int? maKhachSan;
  String tenKhachSan;
  String diaChi;
  String thanhPho;
  String moTa;
  double? danhGiaTrungBinh;
  DateTime? ngayTao;

  KhachSan({
    this.maKhachSan,
    required this.tenKhachSan,
    required this.diaChi,
    required this.thanhPho,
    required this.moTa,
    this.danhGiaTrungBinh,
    this.ngayTao,
  });
}
