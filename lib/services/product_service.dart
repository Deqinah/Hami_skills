import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductService {
  static const String _productsPath = 'assets/data/products.json';

  // Load products from JSON file
  Future<List<Product>> loadProducts() async {
    try {
      final String jsonString = await rootBundle.loadString(_productsPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products: $e');
      // Return sample products if JSON fails
      return _getSampleProducts();
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final products = await loadProducts();
    if (category == 'All') {
      return products;
    }
    return products.where((product) => product.category == category).toList();
  }

  // Search products by name
  Future<List<Product>> searchProducts(String query) async {
    final products = await loadProducts();
    if (query.isEmpty) {
      return products;
    }
    return products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    final products = await loadProducts();
    final categories = products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  // Get featured products (first 4 products)
  Future<List<Product>> getFeaturedProducts() async {
    final products = await loadProducts();
    return products.take(4).toList();
  }

  // Get product by ID (using name as ID for simplicity)
  Future<Product?> getProductById(String id) async {
    final products = await loadProducts();
    try {
      return products.firstWhere((product) => product.name == id);
    } catch (e) {
      return null;
    }
  }

  // Sample products in case JSON fails
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
      Product(
        name: 'Basal',
        price: 1.2,
        image: '🧅',
        description: 'Basal cusub oo macaan.',
        category: 'Vegetables',
      ),
      Product(
        name: 'Timaatar',
        price: 2.0,
        image: '🍅',
        description: 'Timaatar cusub oo ka yimid beeraha Somaliland.',
        category: 'Vegetables',
      ),
      Product(
        name: 'Batarikh',
        price: 4.5,
        image: '🥑',
        description: 'Batarikh cusub oo macaan.',
        category: 'Fruits',
      ),
      Product(
        name: 'Liin',
        price: 1.0,
        image: '🍋',
        description: 'Liin macaan oo cusub.',
        category: 'Fruits',
      ),
    ];
  }
}