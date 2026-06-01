import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/widgets/appbar/appbar_custom.dart';
import 'package:hotel_booking_app/models/BaseModel/HotelModel.dart';
import 'package:hotel_booking_app/services/hotel_service/hotel_service.dart';
import 'package:hotel_booking_app/services/auth_service/auth_service.dart';
import 'package:hotel_booking_app/screens/khachhang/auth/dangnhap_screen.dart';
import 'package:provider/provider.dart';

class ThongTinKhachSanScreen extends StatefulWidget {
  const ThongTinKhachSanScreen({Key? key}) : super(key: key);

  @override
  State<ThongTinKhachSanScreen> createState() => _ThongTinKhachSanScreenState();
}

class _ThongTinKhachSanScreenState extends State<ThongTinKhachSanScreen> {
  final HotelService _hotelService = HotelService();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  final TextEditingController _tenKhachSanController = TextEditingController();
  final TextEditingController _diaChiController = TextEditingController();
  final TextEditingController _thanhPhoController = TextEditingController();
  final TextEditingController _moTaController = TextEditingController();
  final TextEditingController _anhController = TextEditingController();
  final TextEditingController _danhGiaController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  HotelModel? _hotel;

  @override
  void initState() {
    super.initState();
    _loadHotel();
  }

  @override
  void dispose() {
    _tenKhachSanController.dispose();
    _diaChiController.dispose();
    _thanhPhoController.dispose();
    _moTaController.dispose();
    _anhController.dispose();
    _danhGiaController.dispose();
    super.dispose();
  }

  Future<void> _loadHotel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final hotel = await _hotelService.createDefaultHotelIfEmpty();

      if (!mounted) return;

      setState(() {
        _hotel = hotel;
        _tenKhachSanController.text = hotel.hotelName;
        _diaChiController.text = hotel.address;
        _thanhPhoController.text = hotel.city;
        _moTaController.text = hotel.description;
        _anhController.text = hotel.image;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Lỗi tải thông tin khách sạn: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveHotel() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_hotel?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy ID khách sạn')),
      );
      return;
    }

    final rating =
        double.tryParse(_danhGiaController.text.trim().replaceAll(',', '.')) ??
        0;

    setState(() {
      _isSaving = true;
    });

    try {
      await _hotelService.updateHotel(_hotel!.id!, {
        'hotelName': _tenKhachSanController.text.trim(),
        'address': _diaChiController.text.trim(),
        'city': _thanhPhoController.text.trim(),
        'description': _moTaController.text.trim(),
        'image': _anhController.text.trim(),
        'averageRating': rating,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin khách sạn thành công'),
        ),
      );

      await _loadHotel();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cập nhật thất bại: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _dangXuat() async {
    await _authService.dangXuat();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (_) => const DangNhapScreen()),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F9),
      appBar: CustomAppBar(
        title: 'THÔNG TIN KHÁCH SẠN',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadHotel,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildImagePreview(),

                    const SizedBox(height: 16),

                    _buildFormCard(),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveHotel,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _isSaving ? 'ĐANG LƯU...' : 'LƯU THÔNG TIN KHÁCH SẠN',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6F5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _dangXuat,
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'ĐĂNG XUẤT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadHotel,
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final imageUrl = _anhController.text.trim();

    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isEmpty
          ? const Center(child: Icon(Icons.hotel, size: 70, color: Colors.grey))
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 70, color: Colors.grey),
                );
              },
            ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            label: 'Tên khách sạn',
            controller: _tenKhachSanController,
            icon: Icons.hotel,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập tên khách sạn';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          _buildTextField(
            label: 'Địa chỉ',
            controller: _diaChiController,
            icon: Icons.location_on,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          _buildTextField(
            label: 'Thành phố',
            controller: _thanhPhoController,
            icon: Icons.location_city,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập thành phố';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          _buildTextField(
            label: 'Link ảnh khách sạn',
            controller: _anhController,
            icon: Icons.image,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 14),

          _buildTextField(
            label: 'Điểm đánh giá trung bình',
            controller: _danhGiaController,
            icon: Icons.star,
            keyboardType: TextInputType.number,
            validator: (value) {
              final rating = double.tryParse(
                (value ?? '').trim().replaceAll(',', '.'),
              );

              if (rating == null) {
                return 'Điểm đánh giá phải là số';
              }

              if (rating < 0 || rating > 5) {
                return 'Điểm đánh giá phải từ 0 đến 5';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          _buildTextField(
            label: 'Mô tả khách sạn',
            controller: _moTaController,
            icon: Icons.description,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập mô tả';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
