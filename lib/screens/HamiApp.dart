import 'package:flutter/material.dart';
import '../models/product.dart';
import 'home_screen.dart';
import 'product_list.dart';
import 'product_detail.dart';
import 'cart_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

class HamiApp extends StatefulWidget {
  @override
  _HamiAppState createState() => _HamiAppState();
}

class _HamiAppState extends State<HamiApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(onProductsTap: _navigateToProducts);
      case 1:
        return CartScreen();
      case 2:
        return DashboardScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen(onProductsTap: _navigateToProducts);
    }
  }

  void _navigateToProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(
          products: _getSampleProducts(),
          onProductTap: (product) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Product> _getSampleProducts() {
    return [
      Product(
        name: 'Tufaax',
        price: 2.5,
        image: '🍎',
        description: 'Tufaax cusub oo macaan, laga soo raray beeraha Hargaysa.',
        category: 'Fruits',
      ),
      Product(
        name: 'Moos',
        price: 1.8,
        image: '🍌',
        description: 'Moos khafiif ah oo ka yimid Kenya.',
        category: 'Fruits',
      ),
      Product(
        name: 'Baranbur',
        price: 3.2,
        image: '🍓',
        description: 'Baranbur cusub oo macaan, laga soo raray Ethiopia.',
        category: 'Fruits',
      ),
      Product(
        name: 'Bustaanii',
        price: 2.0,
        image: '🥦',
        description: 'Bustaanii cusub oo ka yimid beeraha Somaliland.',
        category: 'Vegetables',
      ),
      Product(
        name: 'Baradho',
        price: 1.5,
        image: '🍅',
        description: 'Baradho macaan oo cusub.',
        category: 'Vegetables',
      ),
      Product(
        name: 'Qaraha',
        price: 2.8,
        image: '🥒',
        description: 'Qaraha cusub oo qurux badan.',
        category: 'Vegetables',
      ),
    ];
  }
}

