import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productStats = cartProvider.getProductStatistics();
    final mostPopular = productStats.isNotEmpty 
      ? productStats.entries.reduce((a, b) => a.value > b.value ? a : b)
      : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sales Overview Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Soo koobid Iibka',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard('Wadarta Iibka', '\$${cartProvider.getTotalSales().toStringAsFixed(2)}', Icons.attach_money),
                        _buildStatCard('Tirada Alaabta', '${cartProvider.totalItems}', Icons.shopping_basket),
                        _buildStatCard('Nooca Alaabta', '${productStats.length}', Icons.category),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Most Popular Product
            if (mostPopular != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alaabta ugu Badaa',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text('📊', style: TextStyle(fontSize: 20))),
                        ),
                        title: Text(mostPopular.key),
                        subtitle: Text('${mostPopular.value} wakhti ayaa lagu iibiyay'),
                        trailing: Chip(
                          label: Text('Ugu Badaa'),
                          backgroundColor: Color(0xFF2E7D32),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],

            // Product Statistics
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tirakoobka Alaabta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (productStats.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Wali ma jiraan tirakoob alaab ah',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ...productStats.entries.map((entry) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF4CAF50).withOpacity(0.1),
                          child: Text('${entry.value}', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(entry.key),
                        trailing: Text('${entry.value}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      )).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF2E7D32).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF2E7D32), size: 24),
        ),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}