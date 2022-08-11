import 'package:flutter/foundation.dart';

class ProductForm with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  ProductForm({
    this.id,
    this.title,
    this.description,
    this.price = 0,
    this.imageUrl,
    this.isFavorite = false,
  });
}
