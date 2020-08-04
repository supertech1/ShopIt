import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static final id = "/cart_screen";
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    final orderData = Provider.of<Orders_Provider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$" + cartData.totalAmount.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartData: cartData, orderData: orderData)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return CartItemWidget(
                    id: cartData.items.values.toList()[i].id,
                    productId: cartData.items.keys.toList()[i],
                    title: cartData.items.values.toList()[i].title,
                    price: cartData.items.values.toList()[i].price,
                    quantity: cartData.items.values.toList()[i].quantity);
              },
              itemCount: cartData.itemsCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
    @required this.orderData,
  }) : super(key: key);

  final CartProvider cartData;
  final Orders_Provider orderData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading
          ? Container(width: 20, height: 20, child: CircularProgressIndicator())
          : Text(
              "Order now",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
      onPressed: (widget.cartData.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await widget.orderData.addOrder(
                  widget.cartData.items.values.toList(),
                  widget.cartData.totalAmount);
              setState(() {
                isLoading = false;
              });
              widget.cartData.clearCart();
            },
    );
  }
}
