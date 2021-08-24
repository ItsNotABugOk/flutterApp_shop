import 'package:flutter/material.dart';
import 'package:shop/views/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  // ignore: use_key_in_widget_constructors
  const ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailsScreen.routeName, arguments: id);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              onPressed: () {},
              icon: IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            title,
            textScaleFactor: .8,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 23),
            child: IconButton(
              onPressed: () {},
              icon: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
