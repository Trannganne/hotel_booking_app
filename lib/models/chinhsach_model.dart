// models/chinh_sach.dart
class ChinhSach {
  int? maChinhSach;
  int maLoaiPhong;
  bool coBuaSang;
  DateTime hanHuy;
  String chinhSachHoanTien;

  ChinhSach({
    this.maChinhSach,
    required this.maLoaiPhong,
    required this.coBuaSang,
    required this.hanHuy,
    required this.chinhSachHoanTien,
  });
}
