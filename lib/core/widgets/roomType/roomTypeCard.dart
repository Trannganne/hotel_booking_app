import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:intl/intl.dart';

class RoomTypeCard extends StatelessWidget {
  final RoomTypeModel room;
  final List<Amenitymodel> amensList;

  const RoomTypeCard({super.key, required this.room, required this.amensList});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'vi_VN',
      name: 'VND',
    );
    final selectedAmens = room.amensIds
        .map(
          (id) => amensList.firstWhere(
            (u) => u.id == id,
            orElse: () =>
                Amenitymodel(id: '', amenityName: 'Unknown', icon: 'default'),
          ),
        )
        .toList();
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                room.imagesList.isNotEmpty ? room.imagesList[0] : '',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.hotel, size: 100, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.roomTypeName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAmenitiesIcons(selectedAmens),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${room.maxOccupancy} người',
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatCurrency.format(room.pricePerNight),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Tổng tiền: ${formatCurrency.format(room.pricePerNight * 1.1)}', // Example with tax
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Chi tiết',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesIcons(List<Amenitymodel> utils) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: utils.map((u) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _mapStringToIcon(u.icon),
                color: Colors.blue,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 60,
              child: Text(
                u.amenityName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  IconData _mapStringToIcon(String icon) {
    switch (icon) {
      case 'wifi':
        return Icons.wifi;
      case 'bed':
        return Icons.king_bed;
      case 'breakfast':
        return Icons.free_breakfast;
      case 'tv':
        return Icons.tv;
      case 'ac':
        return Icons.ac_unit;
      case 'parking':
        return Icons.local_parking;
      case 'pool':
        return Icons.pool;
      case 'coffee_maker':
        return Icons.coffee_maker;
      case 'desk':
        return Icons.desk;
      case 'balcony':
        return Icons.balcony;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.check_circle;
    }
  }
}
