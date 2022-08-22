// ignore_for_file: file_names
import 'package:flutter/material.dart';

//model
import '../models/product_model.dart';
import '../models/http_exceptions.dart';

//utils
import '../utils/services.dart';

// ignore: camel_case_types
class Products_provider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items;
  final String _token;
  final String _userId;

  Products_provider(
    this._token,
    this._userId,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById({String productId}) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> addProduct({
    @required String title,
    @required String description,
    @required double price,
    @required String imageUrl,
    @required bool isFavorite,
  }) {
    return Services().post(
      path: 'products.json',
      token: _token,
      body: {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'creatorId': _userId,
      },
    ).then(
      (resp) {
        _items.insert(
          0,
          Product(
            id: resp['body']['name'],
            title: title,
            description: description,
            price: price,
            imageUrl: imageUrl,
            isFavorite: isFavorite,
          ),
        );
        notifyListeners();
      },
    ).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchProduct({bool filterByUserId = false}) async {
    String filterString =
        filterByUserId ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    try {
      final Map<String, dynamic> productResponse = await Services()
          .get(path: 'products.json?auth=$_token&$filterString')
          .then((resp) => resp as Map<String, dynamic>);

      final Map<String, dynamic> userFavData = await Services()
          .get(
            path: 'userFavorites/$_userId.json?auth=$_token',
          )
          .then((resp) => resp as Map<String, dynamic>);
      final Map<String, dynamic> extractedData = productResponse['body'];
      final List<Product> tempData = [];
      extractedData.forEach((prodId, prodData) {
        tempData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: userFavData['body'] == null
                ? false
                : userFavData['body'][prodId] ?? false,
          ),
        );
      });
      _items = tempData;
      notifyListeners();
    } catch (error) {
      _items = [];
      notifyListeners();
      rethrow;
    }
  }

  Future<void> editProduct({
    @required String id,
    @required String title,
    @required String description,
    @required double price,
    @required String imageUrl,
    @required bool isFavorite,
  }) {
    return Services().patch(
      path: 'products/$id.json?auth=$_token',
      token: _token,
      body: {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      },
    ).then((resp) {
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      _items[prodIndex] = Product(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        isFavorite: isFavorite,
      );
      notifyListeners();
    }).catchError(
      (error) {
        throw error;
      },
    );
  }

  Future<void> removeItem({@required String id}) async {
    int existingIndex = _items.indexWhere((prod) => prod.id == id);
    Product existingProduct = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();

    return Services()
        .delete(
      path: 'products/$id.json?auth=$_token',
      token: _token,
    )
        .then((resp) {
      final int statusCode = resp['statusCode'] as int;
      if (statusCode >= 400) {
        throw HttpException("Could not delete product.");
      }
    }).catchError((error) {
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw error;
    });
  }
}
