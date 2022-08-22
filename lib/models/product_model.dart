import 'package:flutter/foundation.dart';

//utils
import '../utils/services.dart';
//model
import '../models/http_exceptions.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void toggleFavoriteStatusPATCH(
      bool oldIsFavorite, String userId, String token) {
    Services()
        .put(
      path: 'userFavorites/$userId/$id.json',
      token: token,
      body: isFavorite,
    )
        .catchError((error) {
      isFavorite = oldIsFavorite;
      HttpException("Failed to change Favorite | exception: $error");
    });
  }
}
