import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import 'order_confirmation.dart';

class CheckoutScreen extends StatefulWidget {
  final VoidCallback onOrderConfirmed;

  CheckoutScreen({required this.onOrderConfirmed});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      _nameController.text = authProvider.userName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: cartProvider.cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCheckoutForm(cartProvider, authProvider),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            'Add some products to checkout',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutForm(CartProvider cartProvider, AuthProvider authProvider) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Information
                    Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 8) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Address Field
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Notes Field
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Notes (Optional)',
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 24),

                    // Payment Method
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),

                    _buildPaymentMethodOption(
                      'Cash on Delivery',
                      'Pay when you receive your order',
                      Icons.money,
                    ),
                    _buildPaymentMethodOption(
                      'Credit Card',
                      'Pay securely with your credit card',
                      Icons.credit_card,
                    ),
                    _buildPaymentMethodOption(
                      'Mobile Money',
                      'Pay with your mobile wallet',
                      Icons.phone_android,
                    ),
                    SizedBox(height: 24),

                    // Order Summary
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),

                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Order Items
                            ...cartProvider.cartItems.map((item) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.product.name} x${item.quantity}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    '\$${item.totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),

                            Divider(),
                            SizedBox(height: 8),

                            // Price Breakdown
                            _buildPriceRow('Subtotal:', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
                            _buildPriceRow('Tax (5%):', '\$${cartProvider.taxAmount.toStringAsFixed(2)}'),
                            if (cartProvider.hasDiscount)
                              _buildPriceRow('Discount (10%):', '-\$${cartProvider.discountAmount.toStringAsFixed(2)}'),
                            Divider(),
                            _buildPriceRow(
                              'Total Amount:',
                              '\$${cartProvider.finalTotal.toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confirm Order Button
            Container(
              width: double.infinity,
              height: 60,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _confirmOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirm Order - \$${cartProvider.finalTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(String title, String subtitle, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF2E7D32)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Radio<String>(
          value: title,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Color(0xFF2E7D32),
        ),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = title;
          });
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
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

  void _confirmOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        
        // Simulate API call delay
        await Future.delayed(Duration(seconds: 2));

        // Confirm order
        await cartProvider.confirmOrder(
          _nameController.text,
          _phoneController.text,
          _addressController.text,
        );

        // Navigate to order confirmation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
              name: _nameController.text,
              phone: _phoneController.text,
              address: _addressController.text,
              paymentMethod: _selectedPaymentMethod,
              // onOrderConfirmed: widget.onOrderConfirmed,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}