import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static final id = "/user_product_screen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products_Provider>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.id);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products_Provider>(
                      builder: (ctx, productData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, index) {
                              return UserProductItem(
                                  id: productData.items[index].id,
                                  title: productData.items[index].title,
                                  imageUrl: productData.items[index].imageUrl);
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
