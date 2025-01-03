import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Nội dung chính
         Center (
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               // Nội dung trên (có thể thêm tiêu đề ở đây nếu cần)
               SizedBox(),
               // Hai nút ở dưới cùng
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                 child: Column(
                   children: [
                     // Nút Đăng nhập
                     ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => LoginScreen()),
                         );
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,
                         padding: EdgeInsets.symmetric(vertical: 15),
                         minimumSize:  Size(250, 80), // Chiều rộng tối đa, chiều cao 60
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30),
                         ),
                       ),
                       child: Text(
                         'Log in',
                         style: TextStyle(
                           fontSize: 18,
                           color: Colors.black,
                         ),
                       ),
                     ),
                     SizedBox(height: 40), // Khoảng cách giữa hai nút
                     // Nút Đăng ký
                     ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => RegisterScreen()),
                         );
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.black,
                         padding: EdgeInsets.symmetric(vertical: 15),
                         minimumSize: Size(250, 80), // Chiều rộng tối đa, chiều cao 60
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30),
                         ),
                       ),
                       child: Text(
                         'Sign up',
                         style: TextStyle(
                           fontSize: 18,
                           color: Colors.white,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         )
        ],
      ),
    );
  }
}

