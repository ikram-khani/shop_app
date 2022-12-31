import "package:flutter/material.dart";
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

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
          return Products();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Cart();
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
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routName: (context) => ProductDetailScreen()
        },
      ),
    );
  }
}
