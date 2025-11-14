import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      image: '🛒',
      title: 'Soo dhawoow Hami MiniMarket',
      description: 'Raadi khudaarta iyo miraha cusub ee aad jeceshahay',
      color: Color(0xFF2E7D32),
    ),
    OnboardingPage(
      image: '🍎',
      title: 'Cuntooyin Tayada Sare',
      description: 'Hel khudaar iyo miro cusub oo ka yimid beeraha Somaliland',
      color: Color(0xFF4CAF50),
    ),
    OnboardingPage(
      image: '🚚',
      title: 'Rarid Degdeg ah',
      description: 'Gaarsiinta degdegga ah gurigaaga',
      color: Color(0xFF388E3C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _onboardingPages[_currentPage].color,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  'Bood',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: _onboardingPages[index]);
                },
              ),
            ),
            
            // Indicators and Next Button
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  
                  // Next Button
                  FloatingActionButton(
                    onPressed: () {
                      if (_currentPage < _onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      }
                    },
                    child: Icon(
                      _currentPage == _onboardingPages.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                      color: Color(0xFF2E7D32),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String image;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.color,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji/Image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                page.image,
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          
          SizedBox(height: 40),
          
          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 20),
          
          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}