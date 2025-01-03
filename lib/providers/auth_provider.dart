import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  // Hàm load token từ UserService (SharedPreferences)
  Future<void> loadToken() async {
    final token = await UserService().getToken();
    _token = token;
    notifyListeners();
  }

  // Hàm set token (nếu cần cập nhật token thủ công)
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  // Hàm xóa token (ví dụ khi người dùng đăng xuất)
  void clearToken() {
    _token = null;
    notifyListeners();
  }
}
