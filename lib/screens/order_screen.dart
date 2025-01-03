import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../services/user_service.dart';

class OrderScreen extends StatefulWidget {
  final double totalPrice; // Tổng tiền từ CartScreen

  const OrderScreen({Key? key, required this.totalPrice}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleCreateOrder(OrderProvider orderProvider) async {
    final addressShip = _addressController.text.trim();

    if (addressShip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userService = UserService();
    final token = await userService.getToken(); // Lấy token từ UserService

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập trước khi tạo đơn hàng!')),
      );
      return;
    }

    final response = await orderProvider.createOrder(
      token: token,
      addressShip: addressShip,
      totalPrice: widget.totalPrice,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo đơn hàng thành công!')));

      // Điều hướng về màn hình chính hoặc màn hình đơn hàng
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Tạo đơn hàng thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Địa chỉ giao hàng:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập địa chỉ giao hàng',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tổng tiền: ${widget.totalPrice.toStringAsFixed(0)} VND',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            orderProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _handleCreateOrder(orderProvider);
                },
                child: const Text('Tạo đơn hàng'),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
