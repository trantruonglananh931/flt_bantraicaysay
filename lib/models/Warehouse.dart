import 'product.dart';

class Warehouse {
  final int? id;
  final Product product;
  final int quantity;

  // Constructor
  Warehouse({
    this.id,
    required this.product,
    required this.quantity,
  });

  // Tạo object từ JSON (parse từ API response)
  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  // Chuyển object thành JSON (khi gửi request đến API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': product.id, 
      'quantity': quantity,
    };
  }
}
