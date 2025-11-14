import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderService {
  static const String _ordersKey = 'orders';

  Future<void> saveOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList(_ordersKey) ?? [];
    
    ordersJson.add(json.encode(order.toJson()));
    await prefs.setStringList(_ordersKey, ordersJson);
  }

  Future<List<Order>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList(_ordersKey) ?? [];
    
    return ordersJson.map((jsonString) {
      final jsonMap = json.decode(jsonString);
      return Order.fromJson(jsonMap);
    }).toList();
  }

  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ordersKey);
  }

  Future<int> getOrdersCount() async {
    final orders = await getOrders();
    return orders.length;
  }

  Future<double> getTotalRevenue() async {
    final orders = await getOrders();
    double total = 0.0; // FIXED: Added explicit type
    for (final order in orders) {
      total += order.totalAmount;
    }
    return total;
  }
}