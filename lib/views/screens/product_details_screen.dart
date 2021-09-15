import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = products.findProductById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () async {},
            centerTitle: true,
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: MediaQuery.of(context).size.width * 0.6,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(loadedProduct.title.trim()),
              centerTitle: true,
              stretchModes: const [
                StretchMode.fadeTitle,
                StretchMode.zoomBackground
              ],
              title: Text(loadedProduct.title),
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Theme.of(context).backgroundColor,
                    Colors.transparent
                  ], begin: Alignment.bottomCenter, end: Alignment.center),
                ),
                child: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description :',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text(
                          loadedProduct.description,
                          // textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 900,
                ),
                const Text('done'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
