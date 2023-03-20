import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
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
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); //won't work here!
    //the issue can be solved through helper constructer
    // Future.delayed(Duration.zero).then(
    //   (value) => Provider.of<Products>(context).fetchAndSetProducts(),
    //this is technically right but there is another approach in dart so we will use that approach (didChangeDependencies)
    // );
    super.initState();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).fetchAndSetProducts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                    child: badges.Badge(
                      position: badges.BadgePosition.topEnd(top: 0, end: 0),
                      badgeContent: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      badgeAnimation: badges.BadgeAnimation.fade(),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: Colors.red,
                      ),
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
