// models/thong_bao.dart
class ThongBao {
  int? maThongBao;
  int maTaiKhoan;
  String tieuDe;
  String noiDung;
  String loai; // DAT_PHONG / THANH_TOAN / HE_THONG
  bool daDoc;
  DateTime? ngayTao;

  ThongBao({
    this.maThongBao,
    required this.maTaiKhoan,
    required this.tieuDe,
    required this.noiDung,
    required this.loai,
    this.daDoc = false,
    this.ngayTao,
  });
}
