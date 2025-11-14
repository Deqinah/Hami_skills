import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Taariikhda Dalabka'),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: FutureBuilder<List<Order>>(
        future: orderService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading orders'));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 20),
                  Text(
                    'Ma jiraan dalab hore',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dalabkaaga ugu horreeya waa kan ku saabsan!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ExpansionTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Dalab #${order.id.substring(order.id.length - 6)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Taariikh: ${_formatDate(order.orderDate)}'),
                      Text('Wadarta: \$${order.totalAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faahfaahin:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...order.items.map((item) => ListTile(
                            leading: Text(item.product.image, style: TextStyle(fontSize: 20)),
                            title: Text(item.product.name),
                            subtitle: Text('${item.quantity} x \$${item.product.price.toStringAsFixed(2)}'),
                            trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                          )).toList(),
                          Divider(),
                          _buildOrderSummaryRow('Wadarta Alaabta:', '\$${order.subtotal.toStringAsFixed(2)}'),
                          _buildOrderSummaryRow('Canshuur:', '\$${order.taxAmount.toStringAsFixed(2)}'),
                          if (order.discountAmount > 0)
                            _buildOrderSummaryRow('Qiimo dhimis:', '-\$${order.discountAmount.toStringAsFixed(2)}'),
                          _buildOrderSummaryRow(
                            'Wadarta Guud:',
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Color(0xFF2E7D32) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}