import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryService {
  final String baseUrl = 'http://10.0.2.2:8000/api/category';

  // Lấy danh sách danh mục
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Tạo danh mục mới
  Future<void> createCategory(String token, Map<String, dynamic> categoryData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(categoryData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create category');
    }
  }

  // Cập nhật danh mục
  Future<void> updateCategory(String token, String id, Map<String, dynamic> categoryData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(categoryData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
