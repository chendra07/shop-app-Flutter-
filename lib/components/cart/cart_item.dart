import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final Function delete;
  final Function modifyQuantity;
  final Function goToDetailScreen;
  final bool hideOpt;
  const CartItem({
    Key key,
    this.productId,
    this.title,
    this.imageUrl,
    this.price,
    this.quantity,
    this.delete,
    this.modifyQuantity,
    this.goToDetailScreen,
    this.hideOpt = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(productId);
    // final productItem = Provider.of<Products_provider>(context);
    return Dismissible(
      key: ValueKey(key),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Do you want to move the item from the cart?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        delete(productId);
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => goToDetailScreen(productId),
                child: Row(
                  children: [
                    ClipRect(
                      child: Image.network(
                        imageUrl,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text('\$ $price'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              hideOpt == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          // onPressed: () => delete(productId),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Are you sure?"),
                                content: const Text(
                                    "Do you want to move the item from the cart?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      delete(productId);
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        IconButton(
                          onPressed: quantity == 1
                              ? null
                              : () => modifyQuantity(productId, -1),
                          icon: Icon(
                            Icons.remove_circle,
                            color: quantity == 1
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () => modifyQuantity(productId, 1),
                            icon: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                      ],
                    )
                  : null,
            ],
          ),
        ),
      ),
    );
  }
}
