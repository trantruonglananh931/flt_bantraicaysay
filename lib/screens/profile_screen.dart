import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'update_user_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profileData = await _authService.getProfile();
      setState(() {
        userInfo = profileData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${error.toString()}')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng xuất: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCB465), // Màu nền
      appBar: AppBar(
        title: Text("Thông tin cá nhân", style: GoogleFonts.roboto()),
        automaticallyImplyLeading: false, // Tắt nút trở về mặc định
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userInfo == null
          ? Center(
        child: Text(
          "Không thể tải thông tin người dùng",
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút trở về tùy chỉnh
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Quay lại màn hình trước
              },
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF8C5A3A), // Màu cho avatar
                  child: Text(
                    userInfo!['username'][0].toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo!['username'] ?? "Unknown",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF995F26), // Màu chữ
                      ),
                    ),
                    Text(
                      userInfo!['email'] ?? "No Email",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.person, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Họ tên",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  subtitle: Text(
                    userInfo!['full_name'] ?? 'Chưa cập nhật',
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.phone, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Số điện thoại",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  subtitle: Text(
                    userInfo!['phone_number'] ?? 'Chưa cập nhật',
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.home, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Địa chỉ",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  subtitle: Text(
                    userInfo!['address'] ?? 'Chưa cập nhật',
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.transgender, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Giới tính",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  subtitle: Text(
                    userInfo!['gender'] ?? 'Chưa cập nhật',
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.cake, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Năm sinh",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  subtitle: Text(
                    userInfo!['birth_year'] ?? 'Chưa cập nhật',
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.edit, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Cập nhật thông tin",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateUserScreen(userInfo: userInfo!)),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.lock, color: const Color(0xFF8C5A3A)),
                  title: Text(
                    "Đổi mật khẩu",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    "Đăng xuất",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF995F26), // Màu chữ
                    ),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
