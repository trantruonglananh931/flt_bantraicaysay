class OrderDetail {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? quantity;
  final double? price;

  OrderDetail({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.price,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
