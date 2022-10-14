import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/user_prodcuts_screen.dart';
import './providers/cart.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', '', []),
            update: (context, value, previous) => Products(value.token,
                value.userId, previous == null ? [] : previous.items),
          ),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders('', '', []),
            update: (context, value, previous) => Orders(value.token,
                value.userId, previous == null ? [] : previous.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: ((context, value, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'MyShop',
                theme: ThemeData(
                  primarySwatch: Colors.teal,
                ),
                home: value.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                        future: value.tryAutoLogin(),
                        builder: (context, snapshot) => snapshot
                                    .connectionState ==
                                ConnectionState.waiting
                            ? Scaffold(body: Center(child: Text('Loading...')))
                            : AuthScreen()),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductScreen.routeName: (ctx) => UserProductScreen(),
                  EditProductScreenState.routeName: (ctx) =>
                      EditProductScreen(),
                  AuthScreen.routeName: (ctx) => AuthScreen(),
                },
              )),
        ));
  }
}
