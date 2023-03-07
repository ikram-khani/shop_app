import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routName = '/user-products';
  const UserProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ProductsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (context, index) => Column(
            children: [
              UserProductItem(ProductsData.items[index].title,
                  ProductsData.items[index].imageUrl),
              const Divider(),
            ],
          ),
          itemCount: ProductsData.items.length,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
