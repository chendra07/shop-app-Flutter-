import 'package:flutter/foundation.dart';

//models
import '../models/orders_model.dart';
import '../models/cart_model.dart';
import '../models/http_exceptions.dart';

//utils
import '../utils/services.dart';

// ignore: camel_case_types
class Orders_provider with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _token;
  final String _userId;

  Orders_provider(this._token, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) {
    final timestamp = DateTime.now();

    return Services().post(
      path: 'orders/$_userId.json?auth=$_token',
      body: {
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'imageUrl': cp.imageUrl,
                })
            .toList(),
      },
    ).then((resp) {
      _orders.insert(
        0,
        OrderItem(
          id: resp['body']['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    });
  }

  Future<void> fetchOrders() {
    return Services().get(path: 'orders/$_userId.json?auth=$_token').then(
      (resp) {
        if (resp['body'] == null) {
          return;
        }

        List<OrderItem> tempData = [];
        (resp['body'] as Map<String, dynamic>).forEach((orderId, orderData) {
          tempData.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity'],
                      imageUrl: item['imageUrl'],
                    ),
                  )
                  .toList(),
            ),
          );
        });
        _orders = tempData;
        notifyListeners();
      },
    ).catchError((error) => throw HttpException("Failed to fetch order data."));
  }
}
