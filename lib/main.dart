import "package:flutter/material.dart";
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return Auth();
        }),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (_, auth, previousProducts) => Products(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Cart();
        }),
        ChangeNotifierProxyProvider<Auth, Orders>(create: (ctx) {
          return Orders('', '', []);
        }, update: (_, auth, previousOrders) {
          return Orders(
            auth.token!,
            auth.userId!,
            previousOrders == null ? [] : previousOrders.orders,
          );
        }),
      ],
      child: Consumer<Auth>(
          builder: (ctx, authData, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'Lato',
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.green,
                    accentColor: Colors.deepOrange,
                  ),
                ),
                title: 'IKi Shop',
                home: authData.isAuth
                    ? const ProductsOverviewScreen()
                    : FutureBuilder(
                        future: authData.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen(),
                      ),
                routes: {
                  ProductDetailScreen.routName: (context) =>
                      const ProductDetailScreen(),
                  CartScreen.routName: (context) => const CartScreen(),
                  OrdersScreen.routName: (context) => const OrdersScreen(),
                  UserProductScreen.routName: (context) => const UserProductScreen(),
                  EditProductScreen.routName: (context) => const EditProductScreen(),
                },
              )),
    );
  }
}
