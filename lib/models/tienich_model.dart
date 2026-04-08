// models/tien_ich.dart
class TienIch {
  int? maTienIch;
  String tenTienIch;
  String icon;
  String loai; // PHONG / KHACH_SAN

  TienIch({
    this.maTienIch,
    required this.tenTienIch,
    required this.icon,
    required this.loai,
  });
}