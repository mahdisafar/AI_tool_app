import 'dart:math';
import 'package:ai_app/core/constants/constant.dart';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════
// 1. VOICE LIVE
// ═══════════════════════════════════════════════════
class VoiceLiveCard extends StatelessWidget {
  final VoidCallback onTap;

  const VoiceLiveCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Constants.boxColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VOICE LIVE',
                    style: TextStyle(
                      color: Constants.accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'آماده برای گفتگو',
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _EqualizerBars(),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// 2. CHAT
// ═══════════════════════════════════════════════════
class ChatCard extends StatelessWidget {
  final VoidCallback onTap;

  const ChatCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Constants.accentColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CHAT',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Icon(Icons.chat_bubble_outline,
                    color: Colors.white.withOpacity(0.4), size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'امروز چطور\nمی‌تونم کمکت کنم؟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'تایپ کن',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// 3. TASKS
// ═══════════════════════════════════════════════════
class TasksCard extends StatelessWidget {
  final VoidCallback onTap;

  const TasksCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Constants.solidGlassColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TASKS',
                  style: TextStyle(
                    color: Constants.accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Icon(Icons.format_list_bulleted,
                    color: Constants.primaryColor.withOpacity(0.6), size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '3',
              style: TextStyle(
                color: Constants.primaryColor,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'تسک ایجاد شده توسط AI',
              style: TextStyle(
                color: Constants.accentColor.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            _taskItem('جلسه با علی فردا'),
            const SizedBox(height: 6),
            _taskItem('ریپورت هفتگی'),
          ],
        ),
      ),
    );
  }

  Widget _taskItem(String text) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Constants.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Constants.accentColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
// 4. CLEAN MESSAGE
// ═══════════════════════════════════════════════════
class CleanMessageCard extends StatelessWidget {
  final VoidCallback onTap;

  const CleanMessageCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Constants.accentColor,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CLEAN MESSAGE',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Constants.boxColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome,
                          size: 14, color: Constants.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        'AI',
                        style: TextStyle(
                          color: Constants.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'سلام، داداش ببین به چیزی...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward,
                    color: Colors.white.withOpacity(0.3), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Constants.boxColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'سلام، می‌خواستم...',
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// ANIMATED EQUALIZER
// ═══════════════════════════════════════════════════
class _EqualizerBars extends StatefulWidget {
  @override
  State<_EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<_EqualizerBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (i) {
            final h =
                8 + (i % 3 + 1) * 5 + sin(_ctrl.value * 2 * pi + i * 0.8) * 10;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: 4,
              height: h.clamp(6.0, 34.0),
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
