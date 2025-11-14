import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_switcher.dart';
import 'order_history.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (!authProvider.isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 80, color: Colors.grey[400]),
              SizedBox(height: 20),
              Text(
                'Ma login garan',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Text(
                'Login si aad u aragto profilekaaga',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFF2E7D32),
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Profilekaaga'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                ),
              ),
            ),
            actions: [
              LanguageSwitcher(),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xFF2E7D32),
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          SizedBox(height: 15),
                          Text(
                            authProvider.userName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            authProvider.userEmail,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Menu Items
                  _buildMenuButton(
                    Icons.history,
                    'Taariikhda Dalabka',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
                      );
                    },
                  ),
                  _buildMenuButton(Icons.favorite, 'Kuwa aad jeceshahay', () {}),
                  _buildMenuButton(Icons.location_on, 'Cinwaannada', () {}),
                  _buildMenuButton(Icons.notifications, 'Ogeysiisyada', () {}),
                  _buildMenuButton(Icons.help, 'Gargaar', () {}),
                  _buildMenuButton(Icons.settings, 'Dejinta', () {}),
                  _buildMenuButton(
                    Icons.logout,
                    'Ka bax',
                    () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ka bax'),
                          content: Text('Ma hubtaa inaad rabto inaad ka baxdo?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Jooji'),
                            ),
                            TextButton(
                              onPressed: () {
                                authProvider.logout();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text('Haa, ka bax', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Color(0xFF2E7D32)),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}