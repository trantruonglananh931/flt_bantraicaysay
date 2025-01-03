import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_detai_screen.dart';

class MyOrderScreen extends StatefulWidget {
  final String token;

  const MyOrderScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi fetchMyOrders trong initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .fetchMyOrders(token: widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch sử mua hàng",
          style: GoogleFonts.roboto(), // Sử dụng font Roboto
        ),
        backgroundColor: const Color(0xFFFCB465), // Màu nền AppBar
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.myOrders.isEmpty
          ? const Center(child: Text("Bạn chưa có đơn hàng nào."))
          : ListView.builder(
        itemCount: orderProvider.myOrders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.myOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(
                "Đơn hàng #${order['id']}",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8C5A3A), // Màu chữ
                ),
              ),
              subtitle: Text(
                "Tổng tiền: ${order['total_price']} VND",
                style: GoogleFonts.roboto(
                  color: const Color(0xFF995F26), // Màu chữ phụ
                ),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(orderId: order['id'].toString()),
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
