import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/cart_provider.dart';
import './providers/orders.dart';
import './providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) {
            return Auth_Provider();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) {
            return Products_Provider();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) {
            return CartProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) {
            return Orders_Provider();
          },
        )
      ],
      child: Consumer<Auth_Provider>(
        builder: (ctx, authProvider, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: authProvider.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            AuthScreen.id: (context) => AuthScreen(),
            ProductOverviewScreen.id: (context) => ProductOverviewScreen(),
            ProductDetailScreen.id: (context) => ProductDetailScreen(),
            CartScreen.id: (context) => CartScreen(),
            Orders_Screen.id: (context) => Orders_Screen(),
            UserProductsScreen.id: (context) => UserProductsScreen(),
            EditProductScreen.id: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
