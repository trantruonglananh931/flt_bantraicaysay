import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Cart.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // Thay bằng URL API của bạn

  Future<Cart?> getCart(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<void> addToCart(String token, int productId, int quantity, double price) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
        'price': price,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product to cart');
    }
  }

  Future<void> updateCart(String token, int productId, int quantity) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart');
    }
  }

  Future<void> removeFromCart(String token, int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove product from cart');
    }
  }
}
