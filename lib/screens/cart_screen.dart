import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_badge.dart';
import 'checkout_screen.dart';
import 'product_list.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Gaarigaaga'),
          backgroundColor: Color(0xFF2E7D32),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
              SizedBox(height: 20),
              Text(
                'Gaarigaaga waa madhan',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Text(
                'Ku dar alaab si aad u sii wadato',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListScreen(
                      products: [], // You need to provide the products list here
                      onProductTap: (product) {}, // You need to provide this callback
                    )),
                  );
                },
                child: Text('Daawo Alaabta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gaarigaaga (${cartItems.length})'),
        backgroundColor: Color(0xFF2E7D32),
        actions: [
          CartBadge(
            itemCount: cartProvider.totalItems,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Nadiifinta Gaariga'),
                  content: Text('Ma hubtaa inaad rabto inaad ka saarto dhammaan alaabta?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Jooji'),
                    ),
                    TextButton(
                      onPressed: () {
                        cartProvider.clearCart();
                        Navigator.pop(context);
                      },
                      child: Text('Haa, Nadiifi', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(item.product.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    cartProvider.removeFromCart(item.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.product.name} waa laga saaray gaariga'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            item.product.image,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      title: Text(
                        item.product.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${item.product.price.toStringAsFixed(2)}'),
                          Text(
                            'Wadarta: \$${item.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () => cartProvider.decreaseQuantity(item.product),
                          ),
                          Text(
                            '${item.quantity}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline, color: Color(0xFF2E7D32)),
                            onPressed: () => cartProvider.increaseQuantity(item.product),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
              ],
            ),
            child: Column(
              children: [
                if (cartProvider.hasDiscount)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.discount, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '10% Discount Applied! Saved \$${cartProvider.discountAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                _buildPriceRow('Wadarta Alaabta:', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
                _buildPriceRow('Canshuur (5%):', '\$${cartProvider.taxAmount.toStringAsFixed(2)}'),
                if (cartProvider.hasDiscount)
                  _buildPriceRow('Qiimo dhimis (10%):', '-\$${cartProvider.discountAmount.toStringAsFixed(2)}'),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wadarta Guud',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${cartProvider.finalTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            onOrderConfirmed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Sii wato Dalabka',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}