import 'package:ai_app/config/routs/approutes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfessionalOnboarding extends StatefulWidget {
  const ProfessionalOnboarding({super.key});

  @override
  State<ProfessionalOnboarding> createState() => _ProfessionalOnboardingState();
}

class _ProfessionalOnboardingState extends State<ProfessionalOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> pages = const [
    {
      'title': 'دستیار صوتی هوشمند',
      'subtitle':
          'هر چی تو ذهنته رو به من بگو، من صدات رو می‌شنوم و درک می‌کنم',
      'image': 'assets/images/person1.png',
      'backgroundColor': Color.fromARGB(255, 255, 255, 255),
      'textColor': Color(0xFF0D47A1),
    },
    {
      'title': 'دانش بی‌پایان',
      'subtitle': 'از حل مسائل پیچیده تا نوشتن برنامه‌های تو، همه اینجاست',
      'image': 'assets/images/person2.png',
      'backgroundColor': Color.fromARGB(255, 255, 255, 255),
      'textColor': Color(0xFF0D47A1),
    },
    {
      'title': 'خلاقیت بی مرز',
      'subtitle': 'ایده‌هاتو به واقعیت تبدیل کن. من کمکت می‌کنم بهتر بسازی',
      'image': 'assets/images/person3.png',
      'backgroundColor': Color.fromARGB(255, 255, 255, 255),
      'textColor': Color(0xFF0D47A1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: pages[_currentPage]['backgroundColor'],
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = pages[index];
                return Column(
                  children: [
                    const SizedBox(height: 60),
                    SizedBox(
                      height: screenSize.height * 0.45,
                      width: double.infinity,
                      child: Image.asset(
                        page['image'],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.blue, Colors.purple, Colors.red],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(bounds),
                            child: Text(
                              page['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: page['textColor'],
                                fontSize: 28,
                                fontFamily: "IranYekan",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            page['subtitle'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  (page['textColor'] as Color).withOpacity(0.8),
                              fontSize: 16,
                              fontFamily: "Lalezar",
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            
            Positioned(
              bottom: 60,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 5),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: pages[_currentPage]['textColor'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.decelerate,
                        );
                      } else {
                        context.pushReplacement(AppRoutes.home);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pages[_currentPage]['textColor'],
                      foregroundColor: pages[_currentPage]['backgroundColor'],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == pages.length - 1 ? "بزن بریم" : "بعدی",
                      style: const TextStyle(
                        fontFamily: "IranYekan",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
