import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import '../screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello Friend!"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text('Shop'),
            onTap: (() => Navigator.of(context).pushReplacementNamed('/')),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.payment,
            ),
            title: const Text('Orders'),
            onTap: (() => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routName)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text('Manage Products'),
            onTap: (() => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routName)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
