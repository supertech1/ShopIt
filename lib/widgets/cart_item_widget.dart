import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItemWidget(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title,
      @required this.productId});

  // Widget QuantityControls() {
  //   return Container(
  //     width: 100,
  //     child: Row(
  //       children: <Widget>[
  //         Text("Qty:"),
  //         IconButton(
  //           iconSize: 10,
  //           icon: Icon(Icons.arrow_drop_up),
  //           onPressed: () {},
  //         ),
  //         Text("4"),
  //         IconButton(
  //           iconSize: 10,
  //           icon: Icon(Icons.arrow_drop_down),
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartData.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure"),
                  content: Text("Do you want to remove the content from cart?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ));
      },
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(child: Text("\$ $price")),
                ),
              ),
              title: Text(title),
              subtitle: Text("Total: \$ ${price * quantity}"),
              trailing: Text("Qty: $quantity")),
        ),
      ),
    );
  }
}
