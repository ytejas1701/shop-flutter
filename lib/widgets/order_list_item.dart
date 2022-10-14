import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderListItem extends StatefulWidget {
  final OrderItem order;
  OrderListItem(this.order);

  @override
  State<StatefulWidget> createState() {
    return OrderListItemState();
  }
}

class OrderListItemState extends State<OrderListItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
            title: Text(
              '₹${widget.order.amount}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: isExpanded
                  ? Icon(Icons.expand_less_sharp)
                  : Icon(Icons.expand_more_sharp),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            )),
        if (isExpanded)
          Container(
            height: min(80, widget.order.listItems.length * 20.00),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: ListView(
              children: widget.order.listItems.map(((e) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${e.title} x ${e.quantity}'),
                      Text('${e.price * e.quantity}')
                    ]);
              })).toList(),
            ),
          ),
      ]),
    );
  }
}
