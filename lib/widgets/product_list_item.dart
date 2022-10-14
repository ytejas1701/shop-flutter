import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class ProductListItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductListItem({this.title, this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(title),
      trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        EditProductScreenState.routeName,
                        arguments: id);
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('Delete Item'),
                            content: Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    try {
                                      await Provider.of<Products>(context,
                                              listen: false)
                                          .removeProduct(id);
                                    } catch (error) {
                                      scaffoldMessenger.showSnackBar(SnackBar(
                                          content:
                                              Text('Oops! An error ocurred.')));
                                    }
                                  },
                                  child: Text('Delete')),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.delete))
            ],
          )),
    );
  }
}
