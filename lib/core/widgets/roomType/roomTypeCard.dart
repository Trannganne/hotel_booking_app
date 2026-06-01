import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/AmenityModel.dart';
import 'package:hotel_booking_app/models/BaseModel/RoomTypeModel.dart';
import 'package:intl/intl.dart';

class RoomTypeCard extends StatelessWidget {
  final RoomTypeModel roomType;
  final List<Amenitymodel> amensList;
  final VoidCallback? onTap;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RoomTypeCard({
    super.key,
    required this.roomType,
    required this.amensList,
    this.onTap,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final selectedAmens = roomType.amensIds
        .map(
          (id) => amensList.firstWhere(
            (u) => u.id == id,
            orElse: () =>
                Amenitymodel(id: '', amenityName: 'Không rõ', icon: 'default'),
          ),
        )
        .toList();

    final imageUrl = roomType.imagesList.isNotEmpty
        ? roomType.imagesList.first
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(imageUrl),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomType.roomTypeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    formatCurrency.format(roomType.pricePerNight),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildInfoRow(
                    Icons.square_foot,
                    'Diện tích: ${roomType.area.toStringAsFixed(0)} m²',
                  ),
                  _buildInfoRow(
                    Icons.king_bed,
                    'Giường: ${roomType.bedType} - ${roomType.bedCount} giường',
                  ),
                  _buildInfoRow(
                    Icons.person,
                    'Số khách tối đa: ${roomType.maxOccupancy}',
                  ),
                  _buildInfoRow(Icons.landscape, 'Tầm nhìn: ${roomType.view}'),

                  const SizedBox(height: 10),

                  if (selectedAmens.isNotEmpty)
                    _buildAmenityWrap(selectedAmens),

                  if (onDetail != null ||
                      onEdit != null ||
                      onDelete != null) ...[
                    const SizedBox(height: 12),
                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onDetail != null)
                          TextButton.icon(
                            onPressed: onDetail,
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Chi tiết'),
                          ),

                        if (onEdit != null)
                          TextButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit),
                            label: const Text('Sửa'),
                          ),

                        if (onDelete != null)
                          TextButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'Xóa',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: imageUrl.isEmpty
          ? Container(
              height: 160,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Icon(Icons.hotel, size: 70, color: Colors.grey),
            )
          : Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.broken_image,
                    size: 70,
                    color: Colors.grey,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityWrap(List<Amenitymodel> amenities) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            amenity.amenityName,
            style: const TextStyle(fontSize: 11),
          ),
        );
      }).toList(),
    );
  }
}
