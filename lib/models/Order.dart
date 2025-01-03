import '../models/OrderDetail.dart';
import '../models/PaymentMethod.dart';

class Order {
  final int? id;
  final int? user_id;
  final String? address_ship;
  final double? total_price;
  final String? status;
  final List<OrderDetail>? orderDetails;
  final PaymentMethod? payment_method;

  Order({
    this.id,
    this.user_id,
    this.address_ship,
    this.total_price,
    this.status,
    this.orderDetails,
    this.payment_method,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      user_id: json['user_id'],
      address_ship: json['address_ship'],
      total_price: (json['total_price'] as num?)?.toDouble(),
      status: json['status'],
      orderDetails: json['order_details'] != null
          ? (json['order_details'] as List)
          .map((e) => OrderDetail.fromJson(e))
          .toList()
          : null,
      payment_method: json['payment_method'] != null
          ? PaymentMethod.fromJson(json['payment_method'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'address_ship': address_ship,
      'total_price': total_price,
      'status': status,
      'order_details': orderDetails?.map((e) => e.toJson()).toList(),
      'payment_method': payment_method?.toJson(),
    };
  }
}
