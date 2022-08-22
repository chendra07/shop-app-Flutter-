import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/products_provider.dart';

//routes
import '../routes/routes_config.dart';

//components
import '../components/UI/app_bar.dart';
import '../components/UI/loading_animation.dart';
import '../components/user_product/user_product_item.dart';

//drawer
import '../screens/app_drawer.dart';

class UserProductScreen extends StatefulWidget {
  const UserProductScreen({Key key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  Future<void> _fetchingData(BuildContext context) async {
    await Provider.of<Products_provider>(context, listen: false)
        .fetchProduct(filterByUserId: true);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _fetchingData(context).whenComplete(() {
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
    final products = Provider.of<Products_provider>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final PreferredSizeWidget appBar = CustomAppBar.adaptiveAppBar(
      "Your Products",
      [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoutesConfig.editProductScreen);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: LoadingAnimation.adaptiveLoadingAnimation(),
            )
          : RefreshIndicator(
              onRefresh: () => _fetchingData(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        UserProductItem(
                            id: products.items[index].id,
                            title: products.items[index].title,
                            imageUrl: products.items[index].imageUrl,
                            deleteHandler: () {
                              setState(() => _isLoading = true);
                              products
                                  .removeItem(id: products.items[index].id)
                                  .then((_) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Product deleted!"),
                                  ),
                                );
                              }).catchError((_) {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to delete product!"),
                                  ),
                                );
                              }).whenComplete(() {
                                setState(() => _isLoading = false);
                              });
                            }),
                        const Divider(),
                      ],
                    );
                  },
                  itemCount: products.items.length,
                ),
              ),
            ),
    );
  }
}
