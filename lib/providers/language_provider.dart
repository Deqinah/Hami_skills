import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';


class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = Locale('en', 'US');
  Map<String, String> _localizedStrings = {};

  Locale get currentLocale => _currentLocale;
  Map<String, String> get localizedStrings => _localizedStrings;

  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'so': 'Soomaali',
  };

  LanguageProvider() {
    _loadLocalizedStrings();
  }

  Future<void> _loadLocalizedStrings() async {
    final String languageCode = _currentLocale.languageCode;
    try {
      final String content = await rootBundle.loadString('assets/data/translations_$languageCode.json');
      final Map<String, dynamic> jsonMap = json.decode(content);
      
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      notifyListeners();
    } catch (e) {
      print('Error loading translations: $e');
      // Load default English translations
      _loadDefaultTranslations();
    }
  }

  void _loadDefaultTranslations() {
    _localizedStrings = {
      'welcome': 'Welcome to Hami MiniMarket',
      'fresh_produce': 'Fresh Fruits & Vegetables',
      'products': 'Products',
      'cart': 'Cart',
      'profile': 'Profile',
      'dashboard': 'Dashboard',
      'order_history': 'Order History',
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'add_to_cart': 'Add to Cart',
      'checkout': 'Checkout',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'tax': 'Tax',
      'discount': 'Discount',
      'confirm_order': 'Confirm Order',
      'order_confirmed': 'Order Confirmed!',
      'empty_cart': 'Your cart is empty',
      'browse_products': 'Browse Products',
      'most_popular': 'Most Popular',
      'product_stats': 'Product Statistics',
      'sales_overview': 'Sales Overview',
      'total_sales': 'Total Sales',
      'items_count': 'Items Count',
      'categories_count': 'Categories Count'
    };
    notifyListeners();
  }

  Future<void> changeLanguage(Locale newLocale) async {
    _currentLocale = newLocale;
    await _loadLocalizedStrings();
    notifyListeners();
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Get supported languages
  Map<String, String> get supportedLanguages => _supportedLanguages;

  // Localizations Delegate for MaterialApp
  get delegate => _AppLocalizationsDelegate(this);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  final LanguageProvider provider;

  _AppLocalizationsDelegate(this.provider);

  @override
  bool isSupported(Locale locale) => ['en', 'so'].contains(locale.languageCode);

  @override
  Future<MaterialLocalizations> load(Locale locale) => SynchronousFuture(_DefaultMaterialLocalizations());

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class _DefaultMaterialLocalizations extends DefaultMaterialLocalizations {}