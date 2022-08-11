import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

//routes
import 'routes/routes_config.dart';

//cfg
import 'utils/cfg_environment.dart';

//provider
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/loading_provider.dart';

//screens
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/zoom_image_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';

void main() async {
  await dotenv.load(fileName: CfgEnvironment.filename);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products_provider>(
          create: (context) => Products_provider(),
        ),
        ChangeNotifierProvider<Cart_provider>(
          create: (context) => Cart_provider(),
        ),
        ChangeNotifierProvider<Orders_provider>(
          create: (context) => Orders_provider(),
        ),
        ChangeNotifierProvider<Loading_provider>(
          create: (context) => Loading_provider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: const Color.fromARGB(255, 255, 0, 0),
            error: Colors.red,
          ),
          fontFamily: "Lato",
        ),
        initialRoute: RoutesConfig.productOverviewScreen,
        routes: {
          RoutesConfig.productOverviewScreen: (ctx) =>
              const ProductOverviewScreen(),
          RoutesConfig.productDetailScreen: (ctx) =>
              const ProductDetailScreen(),
          RoutesConfig.cartScreen: (ctx) => const CartScreen(),
          RoutesConfig.zoomImageScreen: (ctx) => const ZoomImageScreen(),
          RoutesConfig.orderListScreen: (ctx) => const OrderScreen(),
          RoutesConfig.userProductScreen: (ctx) => const UserProductScreen(),
          RoutesConfig.editProductScreen: (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}
