import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderItem extends StatelessWidget {
  final OrderItemM order;
  OrderItem(this.order);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${order.amount.toStringAsFixed(2)}'),
          subtitle: Text(
            DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
          ),
          trailing: IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.expand_more),
          ),
        ),
      ]),
    );
  }
}
