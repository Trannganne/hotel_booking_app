import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceDetailsModel.dart';
import 'package:hotel_booking_app/models/BaseModel/ServiceModel.dart';
import 'package:hotel_booking_app/services/firebase_service/firestore_service.dart';
import 'package:hotel_booking_app/services/service_service/serService.dart';

class ServiceDetailController extends ChangeNotifier {
	final Serservice _service = Serservice();
	final FirestoreService _db = FirestoreService();

	List<ServiceModel> services = [];
	List<ServiceDetailsModel> serviceUsed = [];
	bool isLoading = false;

	CollectionReference<ServiceDetailsModel> get _ref =>
			_db.colWithConverter<ServiceDetailsModel>(
				name: 'service_details',
				fromFirestore: (snap, _) {
					final model = ServiceDetailsModel.fromJson(snap.data()!);
					model.id = snap.id;
					return model;
				},
				toFirestore: (model, _) => model.toJson(),
			);

	Future<void> loadServices() async {
		try {
			isLoading = true;
			notifyListeners();

			services = await _service.getAllServices();
		} catch (e) {
			debugPrint('Lỗi load services: $e');
		} finally {
			isLoading = false;
			notifyListeners();
		}
	}

	Future<void> loadServiceUsedByBookingId(String bookingId) async {
		try {
			isLoading = true;
			notifyListeners();

			final snapshot = await _ref.where('bookingId', isEqualTo: bookingId).get();
			serviceUsed = snapshot.docs.map((doc) => doc.data()).toList();
		} catch (e) {
			debugPrint('Lỗi load serviceDetails: $e');
			serviceUsed = [];
		} finally {
			isLoading = false;
			notifyListeners();
		}
	}

	Future<ServiceDetailsModel?> addServiceUsed(ServiceDetailsModel model) async {
		try {
			final docRef = model.id == null ? _ref.doc() : _ref.doc(model.id);
			model.id = docRef.id;
			await docRef.set(model);
			return model;
		} catch (e) {
			debugPrint('Lỗi add serviceDetails: $e');
			return null;
		}
	}

	Future<void> deleteServiceDetails(String serviceDetailsId) async {
		try {
			await _ref.doc(serviceDetailsId).delete();
		} catch (e) {
			debugPrint('Lỗi delete serviceDetails: $e');
		}
	}

	Future<List<ServiceModel>> getServicesByIds(List<String> ids) async {
		try {
			if (services.isEmpty) {
				await loadServices();
			}

			return services.where((service) => ids.contains(service.id)).toList();
		} catch (e) {
			debugPrint('Lỗi get services by ids: $e');
			return [];
		}
	}

	Future<void> saveServiceUsedItems({
		required String bookingId,
		required Map<String, int> serviceQuantities,
	}) async {
		try {
			for (final entry in serviceQuantities.entries) {
				if (entry.value <= 0) {
					continue;
				}

				await addServiceUsed(
					ServiceDetailsModel(
						serviceId: entry.key,
						bookingId: bookingId,
						quantity: entry.value,
					),
				);
			}
		} catch (e) {
			debugPrint('Lỗi save serviceDetails items: $e');
		}
	}
}