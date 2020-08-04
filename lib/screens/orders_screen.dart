import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import "../widgets/order_item_widget.dart";
import '../widgets/app_drawer.dart';

class Orders_Screen extends StatefulWidget {
  static final id = "/orders_screen";

  @override
  _Orders_ScreenState createState() => _Orders_ScreenState();
}

class _Orders_ScreenState extends State<Orders_Screen> {
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders_Provider>(context, listen: false)
          .fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders_Provider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) {
                return OrderItemWidget(orderData.orders[i]);
              },
            ),
    );
  }
}
