import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//provider
import '../../providers/products_provider.dart';

//component
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorite;
  const ProductsGrid({Key key, this.showOnlyFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products_provider>(context);
    final products =
        showOnlyFavorite ? productData.favoritesItems : productData.items;
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 4,
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
            key: ValueKey(products[index].id),
          ),
        );
      },
    );
  }
}
