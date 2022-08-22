import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/auth_provider.dart';

//screens
import '../screens/order_screen.dart';

//routes
import '../routes/routes_config.dart';
import '../routes/custom_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> listTileItems = [
      {
        'title': 'Shop',
        'icon': Icons.shop,
        'onTap': () {
          Navigator.of(context)
              .pushReplacementNamed(RoutesConfig.productOverviewScreen);
        },
      },
      {
        'title': 'Orders',
        'icon': Icons.payment,
        'onTap': () {
          Navigator.of(context)
              .pushReplacementNamed(RoutesConfig.orderListScreen);
          //     .pushReplacement(
          //   CustomRoute(
          //     builder: (ctx) => const OrderScreen(),
          //   ),
          // );
        },
      },
      {
        'title': 'User Product',
        'icon': Icons.person,
        'onTap': () {
          Navigator.of(context)
              .pushReplacementNamed(RoutesConfig.userProductScreen);
        },
      },
      {
        'title': 'Logout',
        'icon': Icons.logout,
        'onTap': () {
          Provider.of<Auth_provider>(context, listen: false).logout();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(RoutesConfig.authScreen);
        },
      },
    ];

    Widget buildListTiles({
      @required String title,
      @required IconData icon,
      @required Function onTap,
    }) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      );
    }

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello Friend!"),
            automaticallyImplyLeading: false,
          ),
          SingleChildScrollView(
            child: Column(
              children: listTileItems
                  .map(
                    (listTileData) => buildListTiles(
                      title: listTileData['title'],
                      icon: listTileData['icon'],
                      onTap: listTileData['onTap'],
                    ),
                  )
                  .toList(),
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.shop,
          //   ),
          //   title: const Text("Shop"),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(RoutesConfig.productOverviewScreen);
          //   },
          // ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.payment),
          //   title: const Text("Orders"),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(RoutesConfig.orderListScreen);
          //   },
          // ),
          // const Divider(),
        ],
      ),
    );
  }
}
