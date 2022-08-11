import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/orders_provider.dart';

//component
import '../components/order/order_item.dart';
import '../components/UI/app_bar.dart';

//drawer
import '../screens/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key key}) : super(key: key);

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
      body: orderData.orders.isNotEmpty
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
