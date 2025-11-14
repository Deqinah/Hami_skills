import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _taxRate = 0.05; // 5% tax
  final OrderService _orderService = OrderService();

  List<CartItem> get cartItems => _cartItems;
  double get taxRate => _taxRate;

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get taxAmount => subtotal * _taxRate;
  double get totalPrice => subtotal + taxAmount;

  bool get hasDiscount => subtotal > 50;
  double get discountRate => 0.10; // 10% discount
  double get discountAmount => hasDiscount ? subtotal * discountRate : 0;
  double get finalTotal => hasDiscount ? totalPrice - discountAmount : totalPrice;

  CartProvider() {
    _loadCartData();
  }

  // Load cart data from SharedPreferences
  Future<void> _loadCartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getStringList('cartItems');
      
      if (cartData != null) {
        _cartItems = [];
        for (final itemData in cartData) {
          final parts = itemData.split('|');
          if (parts.length == 6) {
            final product = Product(
              name: parts[0],
              price: double.parse(parts[1]),
              image: parts[2],
              description: parts[3],
              category: parts[5],
            );
            final quantity = int.parse(parts[4]);
            _cartItems.add(CartItem(product: product, quantity: quantity));
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }

  // Save cart data to SharedPreferences
  Future<void> _saveCartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _cartItems.map((item) => 
        '${item.product.name}|${item.product.price}|${item.product.image}|${item.product.description}|${item.quantity}|${item.product.category}'
      ).toList();
      
      await prefs.setStringList('cartItems', cartData);
    } catch (e) {
      print('Error saving cart data: $e');
    }
  }

  // Cart methods
  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.name == product.name);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    
    _saveCartData();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.name == product.name);
    _saveCartData();
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final item = _cartItems.firstWhere((item) => item.product.name == product.name);
    item.quantity++;
    _saveCartData();
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final item = _cartItems.firstWhere((item) => item.product.name == product.name);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.removeWhere((cartItem) => cartItem.product.name == product.name);
    }
    _saveCartData();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveCartData();
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _cartItems.any((item) => item.product.name == product.name);
  }

  // Order methods
  Future<void> confirmOrder(String name, String phone, String address) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: name,
      customerPhone: phone,
      customerAddress: address,
      items: List.from(_cartItems),
      subtotal: subtotal,
      taxAmount: taxAmount,
      discountAmount: discountAmount,
      totalAmount: finalTotal,
      orderDate: DateTime.now(),
    );

    await _orderService.saveOrder(order);
    clearCart();
  }

  // Analytics methods for dashboard
  Map<String, int> getProductStatistics() {
    final Map<String, int> stats = {};
    for (final item in _cartItems) {
      stats.update(
        item.product.name,
        (value) => value + item.quantity,
        ifAbsent: () => item.quantity,
      );
    }
    return stats;
  }

  double getTotalSales() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Get cart item by product
  CartItem? getCartItem(Product product) {
    try {
      return _cartItems.firstWhere((item) => item.product.name == product.name);
    } catch (e) {
      return null;
    }
  }
}