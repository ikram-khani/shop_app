import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/products_grid.dart';
import 'package:badges/badges.dart';

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
            Consumer<Cart>(
              builder: ((context, cart, ch) => Container(
                    padding:
                        const EdgeInsets.only(top: 6, right: 15, bottom: 6),
                    child: Badge(
                      badgeContent: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      animationType: BadgeAnimationType.fade,
                      shape: BadgeShape.circle,
                      position: BadgePosition.topEnd(top: 0, end: 0),
                      badgeColor: Colors.red,
                      showBadge: cart.itemCount > 0 ? true : false,
                      child: ch,
                    ),
                  )),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: (() =>
                    Navigator.of(context).pushNamed(CartScreen.routName)),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: ProductsGrid(_showOnlyFavorites));
  }
}
