import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/orders_provider.dart';

//component
import '../components/order/order_item.dart';
import '../components/UI/app_bar.dart';
import '../components/UI/loading_animation.dart';

//drawer
import '../screens/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isInitialFetch = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialFetch) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders_provider>(context, listen: false)
          .fetchOrders()
          .whenComplete(
            () => setState(() {
              _isLoading = false;
              _isInitialFetch = false;
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = CustomAppBar.adaptiveAppBar(
      "Your orders",
      [],
    );

    final orderData = Provider.of<Orders_provider>(context);
    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: LoadingAnimation.adaptiveLoadingAnimation(),
            )
          : orderData.orders.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) => OrderItem(
                    order: orderData.orders[index],
                  ),
                  itemCount: orderData.orders.length,
                )
              : const Center(
                  child: Text("No Orders yet..."),
                ),
    );
  }
}
