import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreenState.routeName),
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ProductListItem(
          title: productsData.items[index].title,
          imageUrl: productsData.items[index].imageUrl,
          id: productsData.items[index].id,
        ),
        itemCount: productsData.items.length,
      ),
      drawer: AppDrawer(),
    );
  }
}
