class Product {
  final int? id;
  final int? categoryId;
  final String? name;
  final double? price;
  final String? thumbnail;
  final String? description;
  final double? weight;

  Product({
    this.id,
    this.categoryId,
    this.name,
    this.price,
    this.thumbnail,
    this.description,
    this.weight,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: double.tryParse(json['price']?.toString() ?? '0'), // Chuyển đổi chuỗi sang double
      thumbnail: json['thumbnail'],
      description: json['description'],
      weight: double.tryParse(json['weight']?.toString() ?? '0'), // Chuyển đổi chuỗi sang double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'price': price,
      'thumbnail': thumbnail,
      'description': description,
      'weight': weight,
    };
  }
}
