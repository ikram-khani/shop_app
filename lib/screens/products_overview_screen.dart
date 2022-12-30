import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOption {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('MyShop'),
          actions: [
            PopupMenuButton(
              onSelected: ((value) {
                setState(() {
                  if (value == FilterOption.Favorites) {
                    //   productsContainer.showFavoritesOnly();
                    _showOnlyFavorites = true;
                  } else {
                    // productsContainer.showAll();
                    _showOnlyFavorites = false;
                  }
                });
              }),
              icon: const Icon(Icons.more_vert),
              itemBuilder: ((context) => [
                    const PopupMenuItem(
                      value: FilterOption.Favorites,
                      child: Text("Only Favorite"),
                    ),
                    const PopupMenuItem(
                      value: FilterOption.All,
                      child: Text("Show All"),
                    ),
                  ]),
            ),
          ],
        ),
        body: ProductsGrid(_showOnlyFavorites));
  }
}
