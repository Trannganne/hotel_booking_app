// controllers/favourite_controller.dart
import 'dart:io';
import 'package:flutter/widgets.dart';
import '../../../models/BaseModel/FavouriteModel.dart';
import '../../../services/favourites_service/favouritesService.dart';

class FavouriteController extends ChangeNotifier {
  final FavouriteService favouriteService = FavouriteService();

  List<FavouriteModel> favourites = [];
  bool isLoading = false;

  Future<void> getAll() async {
    try {
      isLoading = true;
      notifyListeners();

      favourites = await favouriteService.getAll();
    } catch (e) {
      debugPrint("Lỗi load favourite: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavourite(FavouriteModel favourite) async {
    try {
      await favouriteService.addFavourite(favourite);
    } catch (e) {
      debugPrint("Lỗi thêm favourite: $e");
    }
  }

  Future<void> removeFavourite(String id) async {
    try {
      await favouriteService.removeFavourite(id);
    } catch (e) {
      debugPrint("Lỗi xóa favourite: $e");
    }
  }
}
