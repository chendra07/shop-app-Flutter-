// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//routes
import '../routes/routes_config.dart';

//provider
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

//utils
import '../utils/custom_media_query.dart';

//component
import '../components/UI/badge.dart';
import '../components/UI/app_bar.dart';
import '../components/UI/loading_animation.dart';

//screen
import '../components/product_overview/products_grid.dart';

//drawer
import '../screens/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products_provider>(context, listen: false)
          .fetchProduct()
          .whenComplete(() {
        setState(() {
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Cart_provider cart = Provider.of<Cart_provider>(context);
    final PreferredSizeWidget appBar = CustomAppBar.adaptiveAppBar(
      "Any Shop",
      [
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (selectedValue == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          icon: const Icon(
            Icons.more_vert,
          ),
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: FilterOptions.Favorites,
              child: Text('Only Favorites'),
            ),
            PopupMenuItem(
              value: FilterOptions.All,
              child: Text('Show All'),
            ),
          ],
        ),
        Consumer<Cart_provider>(
          builder: (ctx, cartData, child) =>
              Badge(value: cart.itemCount.toString(), child: child),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesConfig.cartScreen);
            },
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () =>
              Provider.of<Products_provider>(context, listen: false)
                  .fetchProduct(),
          child: Column(
            children: [
              SizedBox(
                height: CMediaQuery.customHeight(context, appBar, 1),
                child: _isLoading
                    ? LoadingAnimation.adaptiveLoadingAnimation()
                    : ProductsGrid(showOnlyFavorite: _showOnlyFavorites),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
