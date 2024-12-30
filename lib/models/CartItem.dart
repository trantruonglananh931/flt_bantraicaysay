class CartItem {
  final int? id;
  final int? cartId;
  final int? productId;
  final int? quantity;
  final double? price;

  CartItem({
    this.id,
    this.cartId,
    this.productId,
    this.quantity,
    this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
