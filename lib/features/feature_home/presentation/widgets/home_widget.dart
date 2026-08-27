import 'dart:math';
import 'package:ai_app/core/constants/utils/extentions.dart';
import 'package:ai_app/features/feature_home/presentation/widgets/category_grid.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F0FE),
              Color(0xFFD6E4F7),
              Color(0xFFE3F0FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            
            ...List.generate(4, (i) {
              return AnimatedBuilder(
                animation: _bgCtrl,
                builder: (context, child) {
                  final wave = sin(_bgCtrl.value * 2 * pi + i * 1.2);
                  return Positioned(
                    top: context.height * (0.05 + i * 0.22) + wave * 18,
                    left: context.width * (0.05 + i * 0.25) + wave * 12,
                    child: Container(
                      width: 160.0 + i * 50,
                      height: 160.0 + i * 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withOpacity(0.07 - i * 0.012),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: context.height * 0.05),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.06),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            "کارهای من",
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Lalezar",
                              shadows: [
                                Shadow(
                                  color: Colors.blue.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const CategoryGrid(),
                  const Spacer(),
                  SizedBox(height: context.height * 0.06),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
