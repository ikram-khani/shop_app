import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(this.id, this.productId, this.title, this.price, this.quantity,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: ((direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(productId)),
      direction: DismissDirection.startToEnd,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(child: Text('\$$price'))),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                content: const Text("Are you sure?"),
                actions: [
                  TextButton(
                      onPressed: (() => Navigator.of(context).pop(false)),
                      child: const Text("No")),
                  TextButton(
                      onPressed: (() => Navigator.of(context).pop(true)),
                      child: const Text('Yes')),
                ],
              )),
        );
      },
    );
  }
}
