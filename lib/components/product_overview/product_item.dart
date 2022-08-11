import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//routes
import '../../routes/routes_config.dart';

//model
import '../../models/product_model.dart';

//provider
import '../../providers/cart_provider.dart';

//component
// import '../UI/customRunningText.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({
    Key key,
    // @required this.id,
    // @required this.title,
    // @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
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
            FadeInImage.assetNetwork(
              placeholder: "assets/images/fading_circles.gif",
              imageErrorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 100,
                child: Center(
                  child: Text("[Cannot fetch image]"),
                ),
              ),
              image: product.imageUrl,
              fit: BoxFit.cover,
            ),
            Text(product.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer<Product>(
                  builder: (cotext, product, child) => IconButton(
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () => product.toggleFavoriteStatus(),
                  ),
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
    // GridTile(
    //   footer:

    // GridTileBar(
    //   backgroundColor: Colors.black87,
    // leading: Consumer<Product>(
    //   builder: (cotext, product, child) => IconButton(
    //     icon: Icon(
    //         product.isFavorite ? Icons.favorite : Icons.favorite_border),
    //     color: Theme.of(context).colorScheme.secondary,
    //     onPressed: () => product.toggleFavoriteStatus(),
    //   ),
    // ),
    //   title: CustomRunningText(
    //     text: product.title,
    //   ),
    //   trailing: IconButton(
    //     icon: const Icon(Icons.shopping_cart),
    //     color: Theme.of(context).colorScheme.secondary,
    //     onPressed: () {
    //       cart.addItem(product.id, product.price, product.title, 1);
    //     },
    //   ),
    // ),
    // child: GestureDetector(
    //   onTap: () {
    //     Navigator.of(context).pushNamed(
    //       RoutesConfig.productDetailScreen,
    //       arguments: product.id,
    //     );
    //   },
    //   child: Image.network(
    //     product.imageUrl,
    //     fit: BoxFit.cover,
    //   ),
    // ),
    // ),
    // );
  }
}
