import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


class ProductService {
  /*final String baseUrl = 'http://10.0.2.2:8000/api/product';*/
  final String baseUrl = 'http://10.0.2.2:8000/api/product';

  Future<List<dynamic>> getProducts({int? categoryId, double? weight, String? sortBy, String? sortOrder}) async {
    String url = baseUrl;

    List<String> queryParams = [];
    if (categoryId != null) queryParams.add('category_id=$categoryId');
    if (weight != null) queryParams.add('weight=$weight');
    if (sortBy != null) queryParams.add('sort_by=$sortBy');
    if (sortOrder != null) queryParams.add('sort_order=$sortOrder');

    if (queryParams.isNotEmpty) {
      url += '?' + queryParams.join('&');
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể tải danh sách sản phẩm');
    }
  }

  Future<dynamic> createProduct(String token, Map<String, dynamic> productData) async {
    final uri = Uri.parse(baseUrl); // Đảm bảo `baseUrl` đã được định nghĩa đúng
    final request = http.MultipartRequest('POST', uri);

    // Thêm header Authorization
    request.headers['Authorization'] = 'Bearer $token';

    // Thêm các trường dữ liệu (trừ thumbnail nếu có)
    productData.forEach((key, value) {
      if (key != 'thumbnail') {
        request.fields[key] = value.toString();
      }
    });

    // Nếu có ảnh (thumbnail), thêm vào dưới dạng file
    if (productData['thumbnail'] != null && productData['thumbnail'] is File) {
      final file = productData['thumbnail'] as File;
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Tên key mà API yêu cầu, thay đổi nếu cần
        file.path,
      ));
    }

    // Gửi request
    final response = await request.send();

    // Xử lý phản hồi
    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      final errorBody = await response.stream.bytesToString();
      throw Exception('Không thể tạo sản phẩm: $errorBody');
    }
  }

  Future<dynamic> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Sản phẩm không tồn tại');
    }
  }

  Future<dynamic> updateProduct(String token, String id, Map<String, dynamic> productData) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể cập nhật sản phẩm: ${response.body}');
    }
  }

  Future<void> deleteProduct(String token,String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);

    if (response.statusCode != 200) {
      throw Exception('Không thể xóa sản phẩm: ${response.body}');
    }
  }
}
