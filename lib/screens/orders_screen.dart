import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //....
              //..Do error handling here
              return const Center(
                child: Text("An error occured!"),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, ordersData, child) {
                return ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: ((context, index) =>
                      OrderItem(ordersData.orders[index])),
                );
              });
            }
          }
        },
      ),
    );
  }
}
