import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'user_service.dart'; // Nhập lớp UserService

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api/auth'; // Địa chỉ API
  final UserService _userService = UserService(); // Khởi tạo UserService

  // Kiểm tra kết nối Internet
  Future<bool> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }

  // Đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String token = data['token'];
      String role = data['role'].trim();
      String username = data['username'];

      // Lưu token vào SharedPreferences
      await _userService.saveToken(token);

      return {
        'token': token,
        'role': role,
        'username': username,
      };
    } else {
      throw Exception('Đăng nhập thất bại: ${response.body}');
    }
  }

  // Đăng ký người dùng
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Đăng ký thất bại: ${response.body}');
    }
  }

  // Đăng ký admin
  Future<Map<String, dynamic>> registerAdmin(Map<String, dynamic> adminData) async {
    String? token = await _userService.getToken();

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/register-admin');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(adminData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Đăng ký admin thất bại: ${response.body}');
    }
  }

  // Lấy thông tin người dùng
  Future<Map<String, dynamic>> getProfile() async {
    String? token = await _userService.getToken();

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể lấy thông tin người dùng: ${response.body}');
    }
  }

  // Cập nhật thông tin người dùng
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> updatedData) async {
    String? token = await _userService.getToken();

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/update-profile');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Cập nhật thông tin thất bại: ${response.body}');
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    String? token = await _userService.getToken();

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Đăng xuất thất bại: ${response.body}');
    }

    // Xóa token khi đăng xuất
    await _userService.clearToken();
  }

  // Đổi mật khẩu
  Future<void> changePassword(String oldPassword, String newPassword) async {
    String? token = await _userService.getToken();

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/change-password');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Đổi mật khẩu thất bại: ${response.body}');
    }
  }

  // Đặt lại mật khẩu
  Future<void> resetPassword(String email, String resetToken, String newPassword) async {
    if (!await _checkConnection()) {
      throw Exception('Không có kết nối Internet');
    }

    final url = Uri.parse('$baseUrl/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'reset_token': resetToken,
        'password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Đặt lại mật khẩu thất bại: ${response.body}');
    }
  }
}
