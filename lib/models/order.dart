import 'cart_item.dart';
import 'product.dart';


class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<CartItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final DateTime orderDate;
  String status;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.orderDate,
    this.status = 'Processing',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((item) => {
        'product': {
          'name': item.product.name,
          'price': item.product.price,
          'image': item.product.image,
          'description': item.product.description,
          'category': item.product.category,
        },
        'quantity': item.quantity,
      }).toList(),
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      items: (json['items'] as List).map((item) => CartItem(
        product: Product(
          name: item['product']['name'],
          price: item['product']['price'],
          image: item['product']['image'],
          description: item['product']['description'],
          category: item['product']['category'],
        ),
        quantity: item['quantity'],
      )).toList(),
      subtotal: json['subtotal'],
      taxAmount: json['taxAmount'],
      discountAmount: json['discountAmount'],
      totalAmount: json['totalAmount'],
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'] ?? 'Processing',
    );
  }

  String get formattedDate {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year} ${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}';
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}