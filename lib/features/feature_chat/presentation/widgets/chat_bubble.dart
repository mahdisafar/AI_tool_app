import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ۱. رنگ‌ها و ترازهای ثابت بر اساس فرستنده
    final bubbleColor = isUser
        ? theme.colorScheme.primary
        : theme.colorScheme.secondaryContainer;

    final textColor = isUser
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSecondaryContainer;

    final alignment =
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isUser ? 16 : 0),
      bottomRight: Radius.circular(isUser ? 0 : 16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          // ۲. حباب چت خالص و ثابت
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
