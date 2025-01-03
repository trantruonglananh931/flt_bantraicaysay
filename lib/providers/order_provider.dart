import 'package:flutter/material.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isLoading = false;

  List<dynamic> _orders = []; // Danh sách tất cả đơn hàng
  List<dynamic> _myOrders = []; // Danh sách đơn hàng của tôi
  List<dynamic> _orderDetails = []; // Chi tiết đơn hàng (danh sách sản phẩm trong đơn hàng)

  bool get isLoading => _isLoading;
  List<dynamic> get orders => _orders;
  List<dynamic> get myOrders => _myOrders;
  List<dynamic> get orderDetails => _orderDetails;

  // Lấy danh sách đơn hàng của tôi
  Future<void> fetchMyOrders({required String token}) async {
    _isLoading = true;
    notifyListeners();

    final response = await _orderService.myOrder(token: token);

    if (response['status'] == 'success') {
      _myOrders = response['data'];
    } else {
      _myOrders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tạo đơn hàng
  Future<Map<String, dynamic>> createOrder({
    required String token,
    required String addressShip,
    required double totalPrice,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _orderService.createOrder(
      token: token,
      addressShip: addressShip,
      totalPrice: totalPrice,
    );

    _isLoading = false;
    notifyListeners();

    return response;
  }

  // Lấy danh sách tất cả đơn hàng
  Future<void> fetchOrders(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await OrderService().getOrders(token: token);
      if (response['status'] == 'success') {
        _orders = response['data'];
      } else {
        _orders = [];
        print('Lỗi: ${response['message']}');
      }
    } catch (e) {
      _orders = [];
      print('Lỗi không xác định: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy chi tiết đơn hàng
  Future<void> fetchOrderDetails({
    required String Id,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _orderService.getOrderDetails(Id: Id);

    if (response is List<dynamic>) {
      _orderDetails = response; // Lưu danh sách chi tiết đơn hàng (danh sách sản phẩm)
    } else {
      _orderDetails = []; // Nếu không thành công, trả về danh sách rỗng
    }

    _isLoading = false;
    notifyListeners();
  }
}