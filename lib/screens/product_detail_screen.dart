import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//utils
import '../utils/custom_media_query.dart';

//component
import '../components/UI/app_bar.dart';
import '../components/UI/image_slider.dart';

//provider
import '../providers/products_provider.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;

    final Product loadedProduct = Provider.of<Products_provider>(
      context,
      listen: false,
    ).findById(productId: productId);

    final PreferredSizeWidget appBar = CustomAppBar.adaptiveAppBar(
      loadedProduct.title,
      [],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(
              imageNetworkList: [
                {
                  'imageUrl': loadedProduct.imageUrl,
                  // 'link': 'https://www.udemy.com/', //just ignore the other properties
                  // 'action': () =>
                  //     Navigator.of(context).pushNamed(RoutesConfig.cartScreen),
                },
                {
                  'imageUrl': loadedProduct.imageUrl,
                  // 'link': 'https://www.udemy.com/',
                  // 'action': () =>
                  //     Navigator.of(context).pushNamed(RoutesConfig.cartScreen),
                },
                {
                  'imageUrl': loadedProduct.imageUrl,
                  // 'link': 'https://www.udemy.com/',
                  // 'action': () =>
                  //     Navigator.of(context).pushNamed(RoutesConfig.cartScreen),
                },
              ],
              heightPct: Utils.customHeight(context, appBar, 0.3),
              isAutoPlay: false,
              viewPortFraction: 1,
              mode: Mode.number,
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Text(
              '\$ ${loadedProduct.price}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Text(
              loadedProduct.description,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
