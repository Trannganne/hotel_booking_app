import 'dart:async';

class PhongService {
  static final List<Map<String, dynamic>> _mockRooms = [
    {'so_phong': 'P101', 'tang': 1, 'loai': 'Deluxe', 'trang_thai': 'TRỐNG'},
    {
      'so_phong': 'P102',
      'tang': 1,
      'loai': 'Suite',
      'trang_thai': 'ĐANG SỬ DỤNG',
    },
    {
      'so_phong': 'P201',
      'tang': 2,
      'loai': 'Standard',
      'trang_thai': 'BẢO TRÌ',
    },
    {'so_phong': 'P301', 'tang': 3, 'loai': 'Standard', 'trang_thai': 'TRỐNG'},
  ];

  /// Lấy danh sách tất cả phòng
  Future<List<Map<String, dynamic>>> getDanhSachPhong() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_mockRooms);
  }

  /// Thêm phòng mới
  Future<bool> themPhong(Map<String, dynamic> phongMoi) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      _mockRooms.add(phongMoi);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> suaPhong(
    String soPhong,
    Map<String, dynamic> thongTinMoi,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    int index = _mockRooms.indexWhere((room) => room['so_phong'] == soPhong);

    if (index != -1) {
      _mockRooms[index] = {..._mockRooms[index], ...thongTinMoi};
      return true;
    }
    return false;
  }

  Future<bool> khoaPhong(String soPhong, bool khoaVinhVien) async {
    await Future.delayed(const Duration(milliseconds: 500));
    int index = _mockRooms.indexWhere((room) => room['so_phong'] == soPhong);

    if (index != -1) {
      _mockRooms[index]['trang_thai'] = khoaVinhVien
          ? 'KHÓA VĨNH VIỄN'
          : 'BẢO TRÌ';
      return true;
    }
    return false;
  }
}
