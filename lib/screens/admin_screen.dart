import 'package:flutter/material.dart';
import 'adm_product_screen.dart';
import 'adm_category_screen.dart';
import 'adm_order_screen.dart';

import 'adm_profile_screen.dart';

class AdminScreens extends StatefulWidget {
  final String token; // Thêm token ở đây

  const AdminScreens({Key? key, required this.token}) : super(key: key);

  @override
  State<AdminScreens> createState() => _AdminScreensState();
}

class _AdminScreensState extends State<AdminScreens> {
  int _selectedIndex = 0;

  // Xử lý khi người dùng nhấn vào một mục trong navbar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình (truyền token vào AdmOrderScreen)
    final List<Widget> _screens = [
      const AdmProductScreen(),
       AdmCategoryScreen(),
      AdmOrderScreen(token: widget.token), // Truyền token vào đây
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Quản lý ADMIN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8C5A3A),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF8C5A3A),
        selectedItemColor: Color(0xFF8C5A3A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );

  }
}
