import 'dart:math';
import 'package:flutter/material.dart';

class VoiceLoadingAnimation extends StatefulWidget {
  const VoiceLoadingAnimation({super.key});

  @override
  State<VoiceLoadingAnimation> createState() => _VoiceLoadingAnimationState();
}

class _VoiceLoadingAnimationState extends State<VoiceLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            
            Transform.rotate(
              angle: _ctrl.value * 2 * pi,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 2,
                  ),
                  gradient: const SweepGradient(
                    colors: [
                      Colors.transparent,
                      Colors.blue,
                      Colors.purple,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.35, 0.65, 1.0],
                  ),
                ),
              ),
            ),

            
            ...List.generate(3, (i) {
              final delay = i * 0.25;
              var val = (_ctrl.value - delay) % 1.0;
              if (val < 0) val += 1.0;

              return Container(
                width: 100 + (i * 18),
                height: 100 + (i * 18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08 * (1 - val)),
                    width: 1.2,
                  ),
                ),
              );
            }),

            
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.4),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        );
      },
    );
  }
}
