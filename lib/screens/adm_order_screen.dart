import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_detai_screen.dart';

class AdmOrderScreen extends StatelessWidget {
  final String token;

  const AdmOrderScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // Gọi fetchOrders nếu danh sách đơn hàng trống
    if (orderProvider.orders.isEmpty && !orderProvider.isLoading) {
      orderProvider.fetchOrders(token);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Danh sách đơn hàng",
          style: TextStyle(color: const Color(0xFF8C5A3A)), // Màu chữ tiêu đề
        ),
        backgroundColor: const Color(0xFFFCB465), // Màu nền app bar
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(
                "Đơn hàng #${order['id']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF995F26), // Màu chữ
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tổng tiền: ${order['total_price']} VND"),
                  Text("Địa chỉ: ${order['address_ship']}"),
                  Text("Trạng thái: ${order['status']}"),

                ],
              ),
              trailing: const Icon(Icons.arrow_forward, color: Color(0xFF8C5A3A)),
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
            ),
          );
        },
      ),
    );
  }
}
