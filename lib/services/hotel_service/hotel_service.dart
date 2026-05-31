import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/models/BaseModel/HotelModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';

class HotelService {
  final db = FirestoreService();

  CollectionReference<HotelModel> get _ref => db.colWithConverter<HotelModel>(
    name: 'hotel',
    fromFirestore: (snap, _) => HotelModel.fromJson(snap.data()!, snap.id),
    toFirestore: (r, _) => r.toJson(),
  );

  Future<List<HotelModel>> getAll() async {
    final snapshot = await _ref.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<HotelModel?> getByID(String id) async {
    final doc = await _ref.doc(id).get();
    return doc.data();
  }

  Future<HotelModel?> getHotel() async {
    final snapshot = await _ref.limit(1).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first.data();
  }

  Future<String> addHotel(HotelModel hotel) async {
    final docRef = _ref.doc();

    hotel.id = docRef.id;

    await docRef.set(hotel);

    return docRef.id;
  }

  Future<void> updateHotel(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  Future<HotelModel> createDefaultHotelIfEmpty() async {
    final currentHotel = await getHotel();

    if (currentHotel != null) {
      return currentHotel;
    }

    final docRef = _ref.doc();

    final defaultHotel = HotelModel(
      id: docRef.id,
      hotelName: 'HotelBank',
      address: 'Chưa cập nhật địa chỉ',
      city: 'Chưa cập nhật thành phố',
      description: 'Chưa cập nhật mô tả khách sạn',
      image: '',
    );

    await docRef.set(defaultHotel);

    return defaultHotel;
  }
}
