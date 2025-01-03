import 'CartItem.dart';

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;

  Cart({required this.id, required this.userId, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}
