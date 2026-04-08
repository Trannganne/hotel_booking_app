// models/loai_phong.dart
import 'tienich_model.dart'; // Import class TienIch nếu bạn có

class LoaiPhong {
  int? maLoaiPhong;
  String tenLoaiPhong;
  double dienTich;
  String loaiGiuong;
  int soLuongGiuong;
  int soKhachToiDa;
  String huongPhong;
  String moTa;
  List<TienIch> danhSachTienIch; // danh sách tiện ích, mặc định rỗng

  LoaiPhong({
    this.maLoaiPhong,
    required this.tenLoaiPhong,
    required this.dienTich,
    required this.loaiGiuong,
    required this.soLuongGiuong,
    required this.soKhachToiDa,
    required this.huongPhong,
    required this.moTa,
    List<TienIch>? danhSachTienIch,
  }) : danhSachTienIch = danhSachTienIch ?? [];
}
