import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  late GoogleMapController mapController;
  LatLng? _userLocation;
  double _distance = 0.0;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  final LatLng _center = const LatLng(10.80623314578309, 106.62865087512147); // Vị trí mặc định (HCM)

  @override
  void initState() {
    super.initState();
    _getUserLocationAndCalculateDistance();
  }

  Future<void> _getUserLocationAndCalculateDistance() async {
    try {
      // Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cần cấp quyền truy cập vị trí')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Lấy vị trí hiện tại của người dùng
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      // Tính khoảng cách giữa vị trí người dùng và vị trí _center
      double distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        _center.latitude,
        _center.longitude,
      );

      // Chuyển đổi từ mét sang km
      double distanceInKm = distance / 1000;

      setState(() {
        _userLocation = userLocation;
        _distance = distanceInKm;
        _isLoading = false;
        _addMarkers();
      });
    } catch (e) {
      print('Lỗi khi lấy vị trí: $e');
      setState(() => _isLoading = false);
    }
  }

  void _addMarkers() {
    _markers.clear();

    // Thêm marker cho vị trí người dùng
    if (_userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation!,
          infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Thêm marker cho vị trí _center (khách sạn)
    _markers.add(
      Marker(
        markerId: const MarkerId('hotel_location'),
        position: _center,
        infoWindow: InfoWindow(
          title: 'Khách sạn',
          snippet: 'Khoảng cách: ${_distance.toStringAsFixed(2)} km',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0077FF),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Khoảng cách đến khách sạn',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_distance.toStringAsFixed(2)} km',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0077FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}