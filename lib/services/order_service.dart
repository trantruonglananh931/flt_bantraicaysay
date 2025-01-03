import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // URL API của bạn

  // Tạo đơn hàng
  Future<Map<String, dynamic>> createOrder({
    required String token,
    required String addressShip,
    required double totalPrice,
  }) async {
    final url = Uri.parse('$baseUrl/order');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'address_ship': addressShip,
          'total_price': totalPrice,
        }),
      );

      if (response.statusCode == 201) {
        return {'status': 'success', 'data': jsonDecode(response.body)};
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Lỗi không xác định';
        return {'status': 'error', 'message': errorMessage};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Đã xảy ra lỗi: $e'};
    }
  }

  // Lấy danh sách đơn hàng của tôi
  Future<Map<String, dynamic>> myOrder({required String token}) async {
    final url = Uri.parse('$baseUrl/my-order');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'status': 'success', 'data': jsonDecode(response.body)};
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Lỗi không xác định';
        return {'status': 'error', 'message': errorMessage};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Đã xảy ra lỗi: $e'};
    }
  }

  // Lấy danh sách tất cả đơn hàng
  Future<Map<String, dynamic>> getOrders({required String token}) async {
    final url = Uri.parse('$baseUrl/order');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        final data = jsonDecode(response.body);
        if (data is List) {
          return {'status': 'success', 'data': data};
        } else {
          return {'status': 'error', 'message': 'Dữ liệu không hợp lệ'};
        }
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Lỗi không xác định';
        return {'status': 'error', 'message': errorMessage};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Không thể kết nối tới server: $e'};
    }
  }

  // Lấy chi tiết đơn hàng
  Future<List<dynamic>> getOrderDetails({
    required String Id,
  }) async {
    final url = Uri.parse('$baseUrl/order/$Id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // API trả về danh sách JSON, do đó parse thành List<dynamic>
        return jsonDecode(response.body);
      } else {
        // Nếu lỗi, trả về danh sách rỗng
        return [];
      }
    } catch (e) {
      // Nếu xảy ra lỗi, trả về danh sách rỗng và in lỗi
      print('Đã xảy ra lỗi khi lấy chi tiết đơn hàng: $e');
      return [];
    }
  }
}
