// models/tai_khoan.dart
class TaiKhoan {
  int? maTaiKhoan;
  String hoTen;
  String email;
  String soDienThoai;
  String matKhau;
  String vaiTro; // KHACH_HANG / QUAN_TRI
  DateTime? ngayTao;

  TaiKhoan({
    this.maTaiKhoan,
    required this.hoTen,
    required this.email,
    required this.soDienThoai,
    required this.matKhau,
    this.vaiTro = 'KHACH_HANG',
    this.ngayTao,
  });
}
