import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  // Danh sách sản phẩm
  List<Product> _products = [];
  List<Product> get products => _products;

  // Trạng thái tải dữ liệu
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lấy danh sách sản phẩm từ API
  Future<void> fetchProducts({
    int? categoryId,
    double? weight,
    String? sortBy,
    String? sortOrder,
  }) async {
    _isLoading = true;
    notifyListeners(); // Cập nhật trạng thái UI

    try {
      // Gọi API để lấy danh sách sản phẩm
      final productList = await _productService.getProducts(
        categoryId: categoryId,
        weight: weight,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      // Chuyển đổi dữ liệu JSON thành danh sách Product
      _products = productList.map((productData) => Product.fromJson(productData)).toList();
    } catch (error) {
      print('Lỗi khi tải sản phẩm: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm sản phẩm mới
  Future<void> addProduct(String token, Map<String, dynamic> productData) async {
    try {
      final newProduct = await _productService.createProduct(token,productData);
      _products.add(Product.fromJson(newProduct));
      notifyListeners(); // Cập nhật UI
    } catch (error) {
      print('Lỗi khi thêm sản phẩm: $error');
      throw error;
    }
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(String token, String id, Map<String, dynamic> productData) async {
    try {
      final updatedProduct = await _productService.updateProduct(token,id, productData);
      final index = _products.indexWhere((product) => product.id == id);
      if (index != -1) {
        _products[index] = Product.fromJson(updatedProduct);
        notifyListeners(); // Cập nhật UI
      }
    } catch (error) {
      print('Lỗi khi cập nhật sản phẩm: $error');
      throw error;
    }
  }

  // Xóa sản phẩm
  Future<void> deleteProduct(String token, String id) async {
    try {
      await _productService.deleteProduct(token,id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners(); // Cập nhật UI
    } catch (error) {
      print('Lỗi khi xóa sản phẩm: $error');
      throw error;
    }
  }

  // Lấy chi tiết sản phẩm (nếu cần)
  Future<Product?> getProduct(String id) async {
    try {
      final productData = await _productService.getProduct(id);
      return Product.fromJson(productData);
    } catch (error) {
      print('Lỗi khi lấy chi tiết sản phẩm: $error');
      return null;
    }
  }
}
