import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/product_model.dart';

//provider
import '../../providers/products_provider.dart';

//component
import './product_item.dart';
import '../UI/loading_animation.dart';

//utils
import '../../utils/custom_media_query.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavorite;
  const ProductsGrid({Key key, this.showOnlyFavorite}) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  bool _isLoading = false;
  int findFitTile(double width) {
    int defaultTile = 2;

    if (width >= 750) {
      defaultTile = 3;
    }

    if (width >= 1200) {
      defaultTile = 4;
    }

    return defaultTile;
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products_provider>(context);
    final List<Product> products = widget.showOnlyFavorite
        ? productData.favoritesItems
        : productData.items;
    return products.isEmpty
        ? Center(
            child: _isLoading
                ? LoadingAnimation.adaptiveLoadingAnimation()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No Product fetched...'),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          productData.fetchProduct().then(
                                (_) => setState(() {
                                  _isLoading = false;
                                }),
                              );
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
          )
        : MasonryGridView.count(
            crossAxisCount: findFitTile(CMediaQuery.customWidht(context, 1)),
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
