import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static final id = "product_detail_screen";
  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    Product product = Provider.of<Products_Provider>(context,
            listen:
                false) //listen will prevent it from rebuilding evrytime there is change since we just want to get data from the source here only
        .findById(productId['selected_product_id']);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  padding: EdgeInsets.all(2),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Text(product.title)),
              background: Hero(
                tag: productId['selected_product_id'],
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Text(
                "\$ ${product.price}",
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
