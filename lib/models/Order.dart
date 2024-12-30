import '../models/OrderDetail.dart';
import '../models/PaymentMethod.dart';

class Order {
  final int? id;
  final int? userId;
  final String? addressShip;
  final double? totalPrice;
  final String? status;
  final List<OrderDetail>? orderDetails;
  final PaymentMethod? paymentMethod;

  Order({
    this.id,
    this.userId,
    this.addressShip,
    this.totalPrice,
    this.status,
    this.orderDetails,
    this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      addressShip: json['address_ship'],
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      status: json['status'],
      orderDetails: json['order_details'] != null
          ? (json['order_details'] as List)
          .map((e) => OrderDetail.fromJson(e))
          .toList()
          : null,
      paymentMethod: json['payment_method'] != null
          ? PaymentMethod.fromJson(json['payment_method'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address_ship': addressShip,
      'total_price': totalPrice,
      'status': status,
      'order_details': orderDetails?.map((e) => e.toJson()).toList(),
      'payment_method': paymentMethod?.toJson(),
    };
  }
}
