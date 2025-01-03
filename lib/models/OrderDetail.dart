class OrderDetail {
  final int? id;
  final int? order_id;
  final int? product_id;
  final int? quantity;
  final double? price;

  OrderDetail({
    this.id,
    this.order_id,
    this.product_id,
    this.quantity,
    this.price,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      order_id: json['order_id'],
      product_id: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': order_id,
      'product_id': product_id,
      'quantity': quantity,
      'price': price,
    };
  }
}
