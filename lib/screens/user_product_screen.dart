import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/products_provider.dart';
import '../providers/loading_provider.dart';

//routes
import '../routes/routes_config.dart';

//components
import '../components/UI/app_bar.dart';
import '../components/UI/loading_animation.dart';
import '../components/user_product/user_product_item.dart';

//drawer
import '../screens/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    final productsData = Provider.of<Products_provider>(context);
    final loadings = Provider.of<Loading_provider>(context);
    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: loadings.screenLoadingState
            ? Center(child: LoadingAnimation.adaptiveLoadingAnimation())
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      UserProductItem(
                          id: productsData.items[index].id,
                          title: productsData.items[index].title,
                          imageUrl: productsData.items[index].imageUrl,
                          deleteHandler: () {
                            productsData.removeItem(
                                id: productsData.items[index].id);
                          }),
                      const Divider(),
                    ],
                  );
                },
                itemCount: productsData.items.length,
              ),
      ),
    );
  }
}
