import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/cart.dart';
import 'package:shop/models/providers/product.dart';
import 'package:shop/views/screens/product_details_screen.dart';

// ignore: use_key_in_widget_constructors
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final carts = Provider.of<Carts>(context, listen: false);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: IconButton(
              icon: Icon(
                  product.favourite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoutiteProduct();
              },
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textScaleFactor: .8,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 23),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                carts.addItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                  children: [
                    Text('${product.title} added to Cart'),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          carts.removeItem(product.id);
                        },
                        child: const Text(
                          'Undo',
                          style: TextStyle(color: Colors.cyan),
                        ))
                  ],
                )));
              },
            ),
          ),
        ),
      ),
    );
  }
}
