import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/user_service.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final userService = UserService();
    final fetchedToken = await userService.getToken();
    setState(() {
      token = fetchedToken;
    });

    if (token != null) {
      Provider.of<CartProvider>(context, listen: false).fetchCart(token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: token == null
          ? const Center(child: Text('Bạn cần đăng nhập để xem giỏ hàng.'))
          : cartProvider.cart == null || cartProvider.cart!.items.isEmpty
          ? const Center(child: Text('Giỏ hàng của bạn đang trống'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cart!.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cart!.items[index];
                return ListTile(
                  /*leading: Image.network(
                    item.product?.imageUrl ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
                  ),*/
                  title: Text(item.product?.name ?? 'Unknown Product'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giá: ${item.price} VND'),
                      Text('Số lượng: ${item.quantity}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item.quantity > 1) {
                            cartProvider.updateCart(
                              token!,
                              item.product!.id,
                              item.quantity - 1,
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartProvider.updateCart(
                            token!,
                            item.product!.id,
                            item.quantity + 1,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cartProvider.removeFromCart(
                            token!,
                            item.product!.id,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tổng giá trị: ${cartProvider.cartTotalPrice} VND',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (cartProvider.cartTotalPrice > 0) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(
                            totalPrice: cartProvider.cartTotalPrice,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Giỏ hàng của bạn đang trống!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Thanh toán'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(CartProvider cartProvider) async {
    try {
      // Xử lý thanh toán (thêm logic thanh toán tại đây)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán thành công!')),
      );

      // Sau khi thanh toán, làm mới giỏ hàng
      if (token != null) {
        await cartProvider.fetchCart(token!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra trong quá trình thanh toán!')),
      );
    }
  }
}
