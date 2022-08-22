import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//routes
import '../../routes/routes_config.dart';

//model
import '../../models/product_model.dart';

//provider
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';

//utils
import '../../utils/debouncer.dart';

//component
// import '../UI/customRunningText.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key key,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final _debouncer = Debouncer(milliseconds: 1500);
  @override
  void dispose() {
    _debouncer.disposeDebounce();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);
    final Auth_provider auth =
        Provider.of<Auth_provider>(context, listen: false);
    final Cart_provider cart =
        Provider.of<Cart_provider>(context, listen: false);
    return Card(
      elevation: 5,
      child: InkWell(
        // borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).pushNamed(
            RoutesConfig.productDetailScreen,
            arguments: product.id,
          );
        },
        child: Column(
          children: [
            Hero(
              tag: product.id,
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/fading_circles.gif",
                imageErrorBuilder: (context, error, stackTrace) =>
                    const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text("[Cannot fetch image]"),
                  ),
                ),
                image: product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Text(product.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    _debouncer.run(() {
                      product.toggleFavoriteStatusPATCH(
                        product.isFavorite,
                        auth.userId,
                        auth.token,
                      );
                    });
                    product.toggleFavoriteStatus();
                  },
                ),
                Text('\$ ${product.price}'),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    cart.addItem(
                      productId: product.id,
                      title: product.title,
                      price: product.price,
                      quantity: 1,
                      imageUrl: product.imageUrl,
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                        "item cart added!",
                      ),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () => cart.removeSingleItem(id: product.id),
                      ),
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
