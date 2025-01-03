import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../screens/admin_screen.dart';
import '../screens/adm_product_screen.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../screens/my_order_screen.dart';
import '../screens/order_list_screen.dart';
import './screens/order_screen.dart';
import 'screens/adm_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FRUZIY',
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => WelcomeScreen(),
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/otp-verification': (context) => const OTPVerificationScreen(),
          '/admin-dashboard': (context) => AdminScreens(
          token: Provider.of<AuthProvider>(context, listen: false)
              .token ?? '',
          ),

          '/adm-products': (context) => const AdmProductScreen(),
          '/cart': (context) => const CartScreen(),
          '/my-orders': (context) => MyOrderScreen(
            token: Provider.of<AuthProvider>(context, listen: false)
                .token ?? '',
          ), // Thêm route cho màn hình MyOrderScreen
        },
      ),
    );
  }
}

