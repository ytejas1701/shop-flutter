import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final title;
  final quantity;
  final price;
  final productId;

  CartListItem(
      {@required this.title,
      @required this.price,
      @required this.quantity,
      @required this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        onDismissed: ((_) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        }),
        key: ValueKey(productId),
        background: Container(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
              size: 40,
            )),
        direction: DismissDirection.endToStart,
        child: Card(
            elevation: 10,
            shadowColor: Theme.of(context).primaryColor,
            child: ListTile(
              leading: Text('₹${price.toStringAsFixed(2)}'),
              title: Text('$title',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark)),
              trailing: Text('x${quantity}'),
            )));
  }
}
