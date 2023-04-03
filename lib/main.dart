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
import 'package:shop_app/screens/user_product_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
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
          create: (ctx) => Products('', []),
          update: (_, auth, previousProducts) => Products(
            auth.token, //no local token,,we have to manage token locally in the app
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Orders();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            accentColor: Colors.deepOrange,
          ),
        ),
        title: 'IKi Shop',
        home: AuthScreen(),
        routes: {
          ProductDetailScreen.routName: (context) => ProductDetailScreen(),
          CartScreen.routName: (context) => CartScreen(),
          OrdersScreen.routName: (context) => OrdersScreen(),
          UserProductScreen.routName: (context) => UserProductScreen(),
          EditProductScreen.routName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
