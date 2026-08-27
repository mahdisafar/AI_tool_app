import 'dart:math' show pi;

import 'package:ai_app/config/routs/approuting.dart';
import 'package:ai_app/config/routs/approutes.dart';

import 'package:ai_app/features/feature_home/presentation/widgets/catogery_card.dart';
import 'package:ai_app/features/feature_voice_chat/presentation/pages/voice_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _orbit;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  final List<Map<String, dynamic>> _cats = [
    {
      'icon': Icons.send_rounded,
      'title': 'پیام',
      'route': AppRoutes.messagesPage
    },
    {
      'icon': Icons.schedule_rounded,
      'title': 'شروع چت',
      'route': AppRoutes.aichatPage
    },
    {
      'icon': Icons.description_rounded,
      'title': 'تسک‌ها',
      'route': AppRoutes.tasksPage
    },
    {'icon': Icons.mic_rounded, 'title': 'چت صوتی', 'isVoice': true},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _orbit = Tween<double>(begin: 2.5 * pi, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _scale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutBack),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(BuildContext ctx, Map<String, dynamic> c) {
    if (c['isVoice'] == true) {
      AppRouting.goTo(ctx, const VoiceChatPage());
    } else {
      context.goNamed(c['route'] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Transform.rotate(
              angle: _orbit.value,
              child: SizedBox(
                width: 270,
                height: 270,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    
                    Align(
                      alignment: Alignment.topCenter,
                      child: Transform.rotate(
                        angle: -_orbit.value,
                        child: CategoryCard(
                          icon: _cats[0]['icon'] as IconData,
                          title: _cats[0]['title'] as String,
                          onTap: () => _onTap(context, _cats[0]),
                        ),
                      ),
                    ),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.rotate(
                        angle: -_orbit.value,
                        child: CategoryCard(
                          icon: _cats[1]['icon'] as IconData,
                          title: _cats[1]['title'] as String,
                          onTap: () => _onTap(context, _cats[1]),
                        ),
                      ),
                    ),
                    
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.rotate(
                        angle: -_orbit.value,
                        child: CategoryCard(
                          icon: _cats[2]['icon'] as IconData,
                          title: _cats[2]['title'] as String,
                          onTap: () => _onTap(context, _cats[2]),
                        ),
                      ),
                    ),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.rotate(
                        angle: -_orbit.value,
                        child: CategoryCard(
                          icon: _cats[3]['icon'] as IconData,
                          title: _cats[3]['title'] as String,
                          onTap: () => _onTap(context, _cats[3]),
                        ),
                      ),
                    ),
                    
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.12),
                            blurRadius: 20,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.blue.shade400,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
