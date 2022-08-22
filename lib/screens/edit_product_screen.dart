import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//component
import '../components/UI/app_bar.dart';
import '../components/UI/loading_animation.dart';

//model
import '../models/product_model.dart';
import '../models/product_form_model.dart';

//provider
import '../providers/products_provider.dart';

//utils
import '../utils/debouncer.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final PreferredSizeWidget _appBar = CustomAppBar.adaptiveAppBar(
    "Edit Product",
    [],
  );
  final _debouncer = Debouncer(milliseconds: 1500);
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  ProductForm _editedProduct = ProductForm();
  bool isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final String productId = ModalRoute.of(context).settings?.arguments;
      if (productId != null) {
        final Product productData =
            Provider.of<Products_provider>(context, listen: false)
                .findById(productId: productId);
        _editedProduct = ProductForm(
          id: productData.id,
          title: productData.title,
          description: productData.description,
          imageUrl: productData.imageUrl,
          price: productData.price,
          isFavorite: productData.isFavorite,
        );
        _imageUrlController.text = productData.imageUrl;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  //prevent memory leak using dispose
  @override
  void dispose() {
    _imageUrlController.dispose();
    _debouncer.disposeDebounce();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _saveForm() {
      final bool isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();

      if (_editedProduct.id == null) {
        setState(() => _isLoading = false);
        Provider.of<Products_provider>(context, listen: false)
            .addProduct(
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite,
        )
            .then((_) {
          setState(() => _isLoading = false);
          Navigator.of(context).pop();
        }).catchError((_) {
          throw showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("An error has occured..."),
              content:
                  const Text("something went wrong, please try again later!"),
              actions: [
                TextButton(
                  child: const Text("Okay"),
                  onPressed: () {
                    setState(() => _isLoading = false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      } else {
        Provider.of<Products_provider>(
          context,
          listen: false,
        ).editProduct(
          id: _editedProduct.id,
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite,
        );
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: _appBar,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _isLoading
            ? Center(
                child: LoadingAnimation.adaptiveLoadingAnimation(),
              )
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _editedProduct.title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please provide the title";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _editedProduct.title = value,
                      ),
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter the price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'price must be greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            _editedProduct.price = double.parse(value),
                      ),
                      TextFormField(
                        initialValue: _editedProduct.description,
                        decoration:
                            const InputDecoration(labelText: 'Descriptions'),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter the descriptions.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 charaters long.';
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct.description = value,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(
                              top: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Center(
                                    child: Text('Enter a URL'),
                                  )
                                : FittedBox(
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/images/fading_circles.gif",
                                      image: _imageUrlController.text,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                              const SizedBox(
                                        height: 100,
                                        child: Center(
                                          child: Text("[Cannot fetch image]"),
                                        ),
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onChanged: (value) {
                                _debouncer.run(() {
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return;
                                  } else {
                                    setState(() {});
                                  }
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter an image URL.';
                                }

                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'please enter a valid URL.';
                                }

                                // if (!value.endsWith('.png') &&
                                //     !value.endsWith('.jpg') &&
                                //     !value.endsWith('..jpeg')) {
                                //   return 'please enter a valid URL.';
                                // }

                                return null;
                              },
                              onSaved: (value) =>
                                  _editedProduct.imageUrl = value,
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _saveForm(),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                        ),
                        icon: const Icon(Icons.save, size: 20),
                        label: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
