import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Models
import 'models/product.dart';
import 'models/cart_item.dart';
import 'models/order.dart';

// Providers
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';

// Screens
import 'screens/splash_screen.dart';


// Services
import 'services/product_service.dart';
import 'services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: HamiMiniMarketApp(),
    ),
  );
}

class HamiMiniMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Hami MiniMarket',
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Color(0xFF2E7D32),
            scaffoldBackgroundColor: Colors.grey[50],
            fontFamily: 'Roboto',
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF2E7D32),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF2E7D32),
            ),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // FIXED: Removed const
              ),
            ),
          ),
          locale: languageProvider.currentLocale,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('so', 'SO'),
          ],
          localizationsDelegates: [
            languageProvider.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Models
// import 'models/product.dart';
// import 'models/cart_item.dart';
// import 'models/order.dart';

// // Providers
// import 'providers/cart_provider.dart';
// import 'providers/auth_provider.dart';
// import 'providers/language_provider.dart';

// // Screens
// import 'screens/splash_screen.dart';
// import 'screens/onboarding_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/product_list.dart';
// import 'screens/product_detail.dart';
// import 'screens/cart_screen.dart';
// import 'screens/checkout_screen.dart';
// import 'screens/order_confirmation.dart';
// import 'screens/order_history.dart';
// import 'screens/dashboard_screen.dart';
// import 'screens/profile_screen.dart';

// // Services
// import 'services/product_service.dart';
// import 'services/order_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => AuthProvider()),
//         ChangeNotifierProvider(create: (context) => CartProvider()),
//         ChangeNotifierProvider(create: (context) => LanguageProvider()),
//       ],
//       child: HamiMiniMarketApp(),
//     ),
//   );
// }

// class HamiMiniMarketApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LanguageProvider>(
//       builder: (context, languageProvider, child) {
//         return MaterialApp(
//           title: 'Hami MiniMarket',
//           theme: ThemeData(
//             primarySwatch: Colors.green,
//             primaryColor: Color(0xFF2E7D32),
//             scaffoldBackgroundColor: Colors.grey[50],
//             fontFamily: 'Roboto',
//             appBarTheme: AppBarTheme(
//               backgroundColor: Color(0xFF2E7D32),
//               elevation: 0,
//               iconTheme: IconThemeData(color: Colors.white),
//             ),
//             floatingActionButtonTheme: FloatingActionButtonThemeData(
//               backgroundColor: Color(0xFF2E7D32),
//             ),
//             cardTheme: CardTheme(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           locale: languageProvider.currentLocale,
//           supportedLocales: [
//             Locale('en', 'US'), // English
//             Locale('so', 'SO'), // Somali
//           ],
//           localizationsDelegates: [
//             languageProvider.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//           home: SplashScreen(),
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }