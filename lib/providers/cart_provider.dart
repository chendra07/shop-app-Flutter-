// ignore_for_file: camel_case_types

import 'package:flutter/foundation.dart';

//model
import '../models/cart_model.dart';

class Cart_provider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  int get itemCount {
    //only count product id
    // return _items == null ? 0 : _items.length;

    //all cart quantity
    int totalCartQty = 0;
    _items.forEach((key, cartItem) {
      totalCartQty += cartItem.quantity;
    });
    return totalCartQty;
  }

  void addItem({
    String productId,
    double price,
    String title,
    String imageUrl,
    int quantity,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          // cartId: existingCartItem.cartId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          // cartId: DateTime.now().toString(),
          title: title,
          price: price,
          imageUrl: imageUrl,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void modifyQuantity({String id, int qty}) {
    _items.update(
      id,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        // cartId: existingCartItem.cartId,
        title: existingCartItem.title,
        price: existingCartItem.price,
        imageUrl: existingCartItem.imageUrl,
        quantity: existingCartItem.quantity + qty,
      ),
    );
    notifyListeners();
  }

  void deleteCartItem({String id}) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem({String id}) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          // cartId: existingCartItem.cartId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
