// models/thanh_toan.dart
class ThanhToan {
  int? maThanhToan;
  int maDatPhong;
  double soTien;
  String phuongThuc; // CHUYEN_KHOAN / QR
  String maGiaoDich;
  String trangThai; // CHO_THANH_TOAN / THANH_CONG / THAT_BAI / DA_HOAN_TIEN
  DateTime? ngayThanhToan;

  ThanhToan({
    this.maThanhToan,
    required this.maDatPhong,
    required this.soTien,
    required this.phuongThuc,
    required this.maGiaoDich,
    required this.trangThai,
    this.ngayThanhToan,
  });
}
