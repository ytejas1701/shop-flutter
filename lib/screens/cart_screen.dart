import 'package:flutter/material.dart';
import '../widgets/cart_list_item.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Column(children: [
        Card(
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Chip(
                      label: Text('₹${cartData.totalAmount.toStringAsFixed(2)}',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      backgroundColor: Colors.white,
                    ),
                  ]),
            )),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => CartListItem(
              title: cartData.items[index].title,
              price: cartData.items[index].price,
              quantity: cartData.items[index].quantity,
              productId: cartData.items[index].productId,
            ),
            itemCount: cartData.items.length,
          ),
        )
      ]),
      bottomNavigationBar: Material(
          color: cartData.items.isEmpty
              ? Colors.grey
              : Theme.of(context).primaryColor,
          child: InkWell(
              onTap: _isLoading
                  ? null
                  : () {
                      return cartData.items.isEmpty
                          ? showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text('Cart is Empty!'),
                                  content: Text('Add items to place an order.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text('Okay'),
                                    )
                                  ],
                                );
                              })
                          : showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text('Place Order'),
                                  content:
                                      Text('Do you want to place this Order?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.of(ctx).pop();

                                          setState(() {
                                            _isLoading = true;
                                          });

                                          await Provider.of<Orders>(context,
                                                  listen: false)
                                              .addOrder(cartData.items,
                                                  cartData.totalAmount);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          cartData.clearCart();
                                        },
                                        child: Text("Yes")),
                                  ],
                                );
                              },
                            );
                    },
              child: SizedBox(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : Center(
                          child: Text('Place Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))))),
    );
  }
}
