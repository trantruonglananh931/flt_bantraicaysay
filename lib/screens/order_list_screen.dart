import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_detai_screen.dart';

class OrderListScreen extends StatelessWidget {
  final String token;

  const OrderListScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách đơn hàng"),
      ),
      body: orderProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
          return ListTile(
            title: Text("Đơn hàng #${order['id']}"),
            subtitle: Text("Tổng tiền: ${order['total_price']}"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(
                    orderId: order['id'].toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
