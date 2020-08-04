import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../screens/edit_product_screen.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title, imageUrl, id;
  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, EditProductScreen.id,
                        arguments: id);
                  },
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<Products_Provider>(context, listen: false)
                        .deleteProduct(id);
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
