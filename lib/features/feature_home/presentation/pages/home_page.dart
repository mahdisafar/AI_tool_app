import 'package:ai_app/config/routs/approuting.dart';
import 'package:ai_app/config/routs/approutes.dart';
import 'package:ai_app/core/constants/constant.dart';
import 'package:ai_app/core/constants/utils/extentions.dart';
import 'package:ai_app/features/feature_voice_chat/presentation/pages/voice_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/feature_select.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.height * 0.05),

              // ─── Header ───
              Text(
                'صبح بخیر',
                style: TextStyle(
                  color: Constants.blackColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'دستیار هوشمند شما',
                style: TextStyle(
                  color: Constants.accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lalezar",
                ),
              ),
              const SizedBox(height: 24),

              // ─── 1. Voice Live ───
              VoiceLiveCard(
                onTap: () => AppRouting.goTo(context, const VoiceChatPage()),
              ),
              const SizedBox(height: 16),

              // ─── 2. Chat & Tasks Row ───
              Row(
                children: [
                  Expanded(
                    child: ChatCard(
                      onTap: () => context.goNamed(AppRoutes.aichatPage),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TasksCard(
                      onTap: () => context.goNamed(AppRoutes.tasksPage),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── 3. Clean Message ───
              CleanMessageCard(
                onTap: () => context.goNamed(AppRoutes.messagesPage),
              ),

              SizedBox(height: context.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
