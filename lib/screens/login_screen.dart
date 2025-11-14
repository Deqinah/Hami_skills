import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'HamiApp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shopping_basket, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Hami MiniMarket',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Fresh Fruits & Vegetables',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Color(0xFF2E7D32),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF2E7D32),
                tabs: [
                  Tab(text: 'Login'),
                  Tab(text: 'Register'),
                ],
              ),
            ),
            
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLoginForm(),
                  _buildRegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _loginEmailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fadlan geli email-kaaga';
                }
                if (!value.contains('@gmail.com')) {
                  return 'Fadlan geli email sax ah';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _loginPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fadlan geli password-kaaga';
                }
                if (value.length < 6) {
                  return 'Password-ku waa inuu ka kooban yahay 6 xaraf';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _mockLogin,
              child: Text(
                'Isticmaal Demo Account',
                style: TextStyle(color: Color(0xFF2E7D32)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _registerNameController,
              decoration: InputDecoration(
                labelText: 'Magacaaga',
                prefixIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fadlan geli magacaaga';
                }
                
                // Hubi in magaca uu ka kooban yahay xarfaf kaliya (lama ogola tirooyin)
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Magacaagu waa inuu ka kooban yahay xarfaf kaliya';
                }
                
                // Hubi in magaca uu ka kooban yahay ugu yaraan 4 xaraf
                if (value.length < 4) {
                  return 'Magacaagu waa inuu ka kooban yahay ugu yaraan 4 xaraf';
                }
                
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _registerEmailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fadlan geli email-kaaga';
                }
                if (!value.contains('@gmail.com')) {
                  return 'Fadlan geli email sax ah';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _registerPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fadlan geli password-kaaga';
                }
                if (value.length < 6) {
                  return 'Password-ku waa inuu ka kooban yahay 6 xaraf';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _registerConfirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fadlan ku celi password-ka';
                }
                if (value != _registerPasswordController.text) {
                  return 'Password-ka ma is waafaqayaan';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

 void _handleLogin() async {
  if (_loginFormKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Hubi in email-ka login iyo email-ka register ay isku mid yihiin
      bool emailMatch = _loginEmailController.text == _registerEmailController.text;
      bool passwordMatch = _loginPasswordController.text == _registerPasswordController.text;
      
      if (emailMatch && passwordMatch) {
        // Haddii email iyo passwordku isku mid yihiin - Login successful
        await authProvider.login(
          _loginEmailController.text,
          _loginPasswordController.text,
          _loginEmailController.text.split('@')[0],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HamiApp()),
        );
      } else {
        // Haddii email ama passwordku aan isku mid ahayn - Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: Email ama password-kaadu waa qalad.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
    } catch (e) {
      // Haddii jiro qalad kale
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
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

  void _handleRegister() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.register(
          _registerEmailController.text,
          _registerPasswordController.text,
          _registerNameController.text,
        );

        // After successful registration, show success message and switch to login tab
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form and switch to login tab
        _registerFormKey.currentState!.reset();
        _tabController.animateTo(0);
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
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

  void _mockLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(
        'demo@hamimarket.com',
        'password',
        'Demo User',
      );

      // Show success message for demo login too
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Demo Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HamiApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }
}









// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import 'HamiApp.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _loginFormKey = GlobalKey<FormState>();
//   final _registerFormKey = GlobalKey<FormState>();
  
//   final _loginEmailController = TextEditingController();
//   final _loginPasswordController = TextEditingController();
  
//   final _registerNameController = TextEditingController();
//   final _registerEmailController = TextEditingController();
//   final _registerPasswordController = TextEditingController();
//   final _registerConfirmPasswordController = TextEditingController();

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(Icons.shopping_basket, size: 40, color: Colors.white),
//                     ),
//                     SizedBox(height: 15),
//                     Text(
//                       'Hami MiniMarket',
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Fresh Fruits & Vegetables',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             // Tab Bar
//             Container(
//               color: Colors.white,
//               child: TabBar(
//                 controller: _tabController,
//                 labelColor: Color(0xFF2E7D32),
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Color(0xFF2E7D32),
//                 tabs: [
//                   Tab(text: 'Login'),
//                   Tab(text: 'Register'),
//                 ],
//               ),
//             ),
            
//             // Tab Bar View
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildLoginForm(),
//                   _buildRegisterForm(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Form(
//         key: _loginFormKey,
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             TextFormField(
//               controller: _loginEmailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF2E7D32)),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Fadlan geli email-kaaga';
//                 }
//                 if (!value.contains('@gmail.com')) {
//                   return 'Fadlan geli email sax ah';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _loginPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 prefixIcon: Icon(Icons.lock, color: Color(0xFF2E7D32)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF2E7D32)),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Fadlan geli password-kaaga';
//                 }
//                 if (value.length < 6) {
//                   return 'Password-ku waa inuu ka kooban yahay 6 xaraf';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 30),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : Container(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _handleLogin,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF2E7D32),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'Login',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
//                       ),
//                     ),
//                   ),
//             SizedBox(height: 20),
//             TextButton(
//               onPressed: _mockLogin,
//               child: Text(
//                 'Isticmaal Demo Account',
//                 style: TextStyle(color: Color(0xFF2E7D32)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRegisterForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Form(
//         key: _registerFormKey,
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//            TextFormField(
//   controller: _registerNameController,
//   decoration: InputDecoration(
//     labelText: 'Magacaaga',
//     prefixIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Color(0xFF2E7D32)),
//       borderRadius: BorderRadius.circular(12),
//     ),
//   ),
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Fadlan geli magacaaga';
//     }
    
//     // Hubi in magaca uu ka kooban yahay xarfaf kaliya (lama ogola tirooyin)
//     if (RegExp(r'[0-9]').hasMatch(value)) {
//       return 'Magacaagu waa inuu ka kooban yahay xarfaf kaliya';
//     }
    
//     // Hubi in magaca uu ka kooban yahay ugu yaraan 4 xaraf
//     if (value.length < 4) {
//       return 'Magacaagu waa inuu ka kooban yahay ugu yaraan 4 xaraf';
//     }
    
//     return null;
//   },
// ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _registerEmailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF2E7D32)),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Fadlan geli email-kaaga';
//                 }
//                 if (!value.contains('@gmail.com')) {
//                   return 'Fadlan geli email sax ah';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _registerPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 prefixIcon: Icon(Icons.lock, color: Color(0xFF2E7D32)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF2E7D32)),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Fadlan geli password-kaaga';
//                 }
//                 if (value.length < 6) {
//                   return 'Password-ku waa inuu ka kooban yahay 6 xaraf';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _registerConfirmPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF2E7D32)), // Fixed: removed extra bracket
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Fadlan ku celi password-ka';
//                 }
//                 if (value != _registerPasswordController.text) {
//                   return 'Password-ka ma is waafaqayaan';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 30),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : Container(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _handleRegister,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF2E7D32),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'Register',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleLogin() async {
//   if (_loginFormKey.currentState!.validate()) {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
//       // Isku day inaad login gasho - haddii uu diiwaan gashan yahay wuu gali doonaa
//       await authProvider.login(
//         _loginEmailController.text,
//         _loginPasswordController.text,
//         _loginEmailController.text.split('@')[0],
//       );

//       // Login successful - haddii uu horey u diiwaan gashan yahay
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Login successful!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HamiApp()),
//       );
//     } catch (e) {
//       // Login failed - haddii aan diiwaan gashan ama password qalad
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Login failed: Ma diiwaan gashan email ama password-kaadu waa qalad.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }

//   void _handleRegister() async {
//     if (_registerFormKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final authProvider = Provider.of<AuthProvider>(context, listen: false);
//         await authProvider.register(
//           _registerEmailController.text,
//           _registerPasswordController.text,
//           _registerNameController.text,
//         );

//         // After successful registration, show success message and switch to login tab
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Registration successful! Please login.'),
//             backgroundColor: Colors.green,
//           ),
//         );
        
//         // Clear form and switch to login tab
//         _registerFormKey.currentState!.reset();
//         _tabController.animateTo(0);
        
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Registration failed: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _mockLogin() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.login(
//         'demo@hamimarket.com',
//         'password',
//         'Demo User',
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HamiApp()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Login failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _loginEmailController.dispose();
//     _loginPasswordController.dispose();
//     _registerNameController.dispose();
//     _registerEmailController.dispose();
//     _registerPasswordController.dispose();
//     _registerConfirmPasswordController.dispose();
//     super.dispose();
//   }
// }