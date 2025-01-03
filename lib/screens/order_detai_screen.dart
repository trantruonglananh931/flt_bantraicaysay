import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .fetchOrderDetails(Id: widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết đơn hàng #${widget.orderId}',
          style: TextStyle(color: const Color(0xFF8C5A3A)), // Màu chữ tiêu đề
        ),
        backgroundColor: const Color(0xFFFCB465), // Màu nền app bar
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.orderDetails.isEmpty
          ? const Center(child: Text("Không tìm thấy chi tiết đơn hàng."))
          : ListView.builder(
        itemCount: orderProvider.orderDetails.length,
        itemBuilder: (context, index) {
          final detail = orderProvider.orderDetails[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.shopping_cart, color: Color(0xFF8C5A3A)),
              title: Text(
                'Sản phẩm ID: ${detail['product_id']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF995F26), // Màu chữ
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Số lượng: ${detail['quantity']}'),
                  Text('Giá: ${detail['price']} VND'),
                ],
              ),
              trailing: Text(
                'Tổng: ${(int.parse(detail['quantity'].toString()) * double.parse(detail['price'].toString())).toStringAsFixed(2)} VND',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF995F26), // Màu chữ
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
