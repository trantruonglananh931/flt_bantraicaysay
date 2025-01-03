import 'package:flutter/material.dart';
import '../models/Cart.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  Cart? _cart; // Giỏ hàng hiện tại
  final CartService _cartService = CartService(); // Service xử lý API giỏ hàng

  Cart? get cart => _cart;

  // Lấy giỏ hàng từ backend
  Future<void> fetchCart(String token) async {
    try {
      _cart = await _cartService.getCart(token);
      notifyListeners(); // Cập nhật giao diện
    } catch (e) {
      print('Error fetching cart: $e');
      throw Exception('Không thể tải giỏ hàng');
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(String token, int productId, int quantity, double price) async {
    try {
      await _cartService.addToCart(token, productId, quantity, price);
      // Sau khi thêm sản phẩm, tải lại giỏ hàng để cập nhật
      await fetchCart(token);
    } catch (e) {
      print('Error adding product to cart: $e');
      throw Exception('Không thể thêm sản phẩm vào giỏ hàng');
    }
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng
  Future<void> updateCart(String token, int productId, int quantity) async {
    try {
      await _cartService.updateCart(token, productId, quantity);
      // Sau khi cập nhật, tải lại giỏ hàng để đảm bảo dữ liệu mới nhất
      await fetchCart(token);
    } catch (e) {
      print('Error updating cart: $e');
      throw Exception('Không thể cập nhật giỏ hàng');
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(String token, int productId) async {
    try {
      await _cartService.removeFromCart(token, productId);
      // Sau khi xóa, tải lại giỏ hàng để cập nhật
      await fetchCart(token);
    } catch (e) {
      print('Error removing product from cart: $e');
      throw Exception('Không thể xóa sản phẩm khỏi giỏ hàng');
    }
  }

  // Lấy tổng số lượng sản phẩm trong giỏ hàng
  int get cartItemCount {
    if (_cart == null || _cart!.items.isEmpty) {
      return 0;
    }
    return _cart!.items.fold(0, (total, item) => total + item.quantity);
  }

  // Lấy tổng giá trị giỏ hàng
  double get cartTotalPrice {
    if (_cart == null || _cart!.items.isEmpty) {
      return 0.0;
    }
    return _cart!.items.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }
}
