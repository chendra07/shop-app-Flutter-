import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//routes
import '../routes/routes_config.dart';

//utils
import '../utils/custom_media_query.dart';
import '../components/cart/cart_item.dart';

//component
import '../components/UI/app_bar.dart';
import '../components/UI/loading_animation.dart';

//provider
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final productItem = Provider.of<Products_provider>(context);
    final cart = Provider.of<Cart_provider>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final PreferredSizeWidget appBar = CustomAppBar.adaptiveAppBar(
      "Your Cart",
      [],
    );

    void modifyQuantity(String id, int qty) {
      cart.modifyQuantity(id: id, qty: qty);
    }

    void deleteCartItem(String id) {
      cart.deleteCartItem(id: id);
    }

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: isLoading
            ? Center(child: LoadingAnimation.adaptiveLoadingAnimation())
            : Column(
                children: [
                  //list of trx.....
                  cart.items.isEmpty
                      ? SizedBox(
                          height:
                              CMediaQuery.customHeight(context, appBar, 0.75),
                          child: const Center(
                            child: Text("No item added yet...."),
                          ),
                        )
                      : SizedBox(
                          height:
                              CMediaQuery.customHeight(context, appBar, 0.7),
                          child: ListView.builder(
                            itemCount: cart.items.length,
                            itemBuilder: ((context, index) {
                              return CartItem(
                                key: ValueKey(
                                    cart.items.values.toList()[index].id),
                                productId: cart.items.values.toList()[index].id,
                                title: cart.items.values.toList()[index].title,
                                price: cart.items.values.toList()[index].price,
                                quantity:
                                    cart.items.values.toList()[index].quantity,
                                imageUrl:
                                    cart.items.values.toList()[index].imageUrl,
                                delete: deleteCartItem,
                                modifyQuantity: modifyQuantity,
                                goToDetailScreen: (String id) =>
                                    Navigator.of(context).pushNamed(
                                        RoutesConfig.productDetailScreen,
                                        arguments: id),
                              );
                            }),
                          ),
                        ),
                  const Divider(color: Colors.black),
                  SizedBox(
                    height: CMediaQuery.customHeight(context, appBar, 0.1),
                    // color: Colors.red,
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "total",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(
                                  '\$',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 20),
                                ),
                              ),
                              label: Text(
                                cart.totalAmount.toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: CMediaQuery.customHeight(context, appBar, 0.1),
                    width: double.infinity,
                    // color: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: ElevatedButton(
                      onPressed: cart.totalAmount <= 0
                          ? null
                          : () {
                              setState(() {
                                isLoading = true;
                              });
                              Provider.of<Orders_provider>(context,
                                      listen: false)
                                  .addOrder(
                                cart.items.values.toList(),
                                cart.totalAmount,
                              )
                                  .then((_) {
                                cart.clearCart();
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Product successfully ordered!"),
                                  ),
                                );
                              }).catchError((_) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Failed to create an order, please try again later"),
                                  ),
                                );
                              }).whenComplete(
                                () => setState(() {
                                  isLoading = false;
                                }),
                              );
                            },
                      child: const Text("Order Now"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
