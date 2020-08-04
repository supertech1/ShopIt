import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../models/product.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static final id = "/product_overview_screen";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = true;

  void filterHandler(bool value) {
    setState(() {
      _showFavoritesOnly = value;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Products_Provider>(context)
          .fetchProduct()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products_Provider>(context);
    List<Product> products = productsData.items;
    if (_showFavoritesOnly) {
      products = products.where((prodItem) => prodItem.isFavorite).toList();
    }
    final cartsData = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: <Widget>[
          Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
            value: cartsData.itemsCount.toString(),
          ),
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.Favorites) {
                  filterHandler(true);
                } else if (selectedValue == FilterOptions.All) {
                  filterHandler(false);
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text("Only Favorites"),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("Show all"),
                      value: FilterOptions.All,
                    ),
                  ]),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              itemBuilder: (ctx, i) {
                return ChangeNotifierProvider.value(
                  value: products[i],
                  // create: (ctx) => products[i], we used .value  approach here,best for  lists and grids
                  child: ProductItem(),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
            ),
    );
  }
}
