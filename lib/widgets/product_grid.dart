import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_grid_item.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  final showFavorite;

  ProductGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productsList =
        showFavorite ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: productsList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
              value: productsList[index], child: ProductGridItem());
        });
  }
}
