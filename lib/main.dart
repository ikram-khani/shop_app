import "package:flutter/material.dart";
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
