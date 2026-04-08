// models/dat_phong.dart
class DatPhong {
  int? maDatPhong;
  int maTaiKhoan;
  int maLoaiPhong;
  DateTime ngayNhan;
  DateTime ngayTra;
  int soKhach;
  int soPhongDat;
  double tongTien;
  String maDon;
  String
  trangThai; // CHO_XAC_NHAN / DA_XAC_NHAN / DA_NHAN_PHONG / DA_TRA_PHONG / DA_HUY / KHONG_DEN
  DateTime? ngayTao;

  DatPhong({
    this.maDatPhong,
    required this.maTaiKhoan,
    required this.maLoaiPhong,
    required this.ngayNhan,
    required this.ngayTra,
    required this.soKhach,
    required this.soPhongDat,
    required this.tongTien,
    required this.maDon,
    required this.trangThai,
    this.ngayTao,
  });
}
