import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shownProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: shownProduct.id);
              },
              child: Image.network(
                shownProduct.imageUrl,
                fit: BoxFit.cover,
              )),
          footer: GridTileBar(
              trailing: IconButton(
                color: Colors.white,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(
                      shownProduct.id, shownProduct.title, shownProduct.price);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Added to Cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.decreaseQuantity(shownProduct.id);
                      },
                    ),
                  ));
                },
              ),
              leading: Consumer<Product>(
                  builder: (_, shownProduct, child) => IconButton(
                        icon: shownProduct.isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border_outlined),
                        onPressed: () {
                          shownProduct.toggleIsFavorite(
                              authData.token, authData.userId);
                        },
                      )),
              backgroundColor: Colors.black54,
              title: Text(
                shownProduct.title,
                textAlign: TextAlign.center,
              )),
        ));
  }
}
