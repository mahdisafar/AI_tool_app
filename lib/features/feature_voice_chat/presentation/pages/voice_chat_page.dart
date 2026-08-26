import 'package:ai_app/features/feature_voice_chat/presentation/bloc/feature_voice_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/livekit_service.dart';
import '../widgets/voice_visualizer.dart';

class VoiceChatPage extends StatefulWidget {
  const VoiceChatPage({super.key});

  @override
  State<VoiceChatPage> createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage>
    with SingleTickerProviderStateMixin {
  late FeatureVoiceChatBloc _bloc;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<FeatureVoiceChatBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(InitialVoiceChatEvent());
    });

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _bloc.add(LeaveChatEvent());
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ai Voice Chat",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1128),
              Color(0xFF1A237E),
              Color(0xFF311B92),
              Color(0xFF4A148C),
            ],
            stops: [0.0, 0.3, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: BlocConsumer<FeatureVoiceChatBloc, FeatureVoiceChatState>(
              listener: (context, state) {
                if (state is OperationErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                VoiceSessionData? sessionData;
                bool isMicEnabled = false;

                if (state is VoiceSessionActiveState) {
                  sessionData = state.sessionData;
                  print("session token: $sessionData");
                  isMicEnabled = state.isMicEnabled;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // === VoiceVisualizer مستقیم ===
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: sessionData != null
                          ? VoiceVisualizer(sessionData: sessionData)
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white54,
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),

                    // === متن وضعیت ===
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        isMicEnabled
                            ? "در حال گوش دادن..."
                            : "چطور می‌توانم کمکتان کنم؟",
                        key: ValueKey(isMicEnabled),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontFamily: "Lalezar",
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: Colors.blue.withOpacity(0.6),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // === دکمه میکروفون نئون ===
                    GestureDetector(
                      onTap: () {
                        if (isMicEnabled) {
                          _bloc.add(StopTalkingEvent());
                        } else {
                          _bloc.add(StartTalkingEvent());
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isMicEnabled
                                ? [
                                    Colors.redAccent.shade200,
                                    Colors.red.shade700,
                                  ]
                                : [
                                    const Color(0xFF448AFF),
                                    const Color(0xFF7C4DFF),
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isMicEnabled
                                  ? Colors.red.withOpacity(0.5)
                                  : const Color(0xFF448AFF).withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: isMicEnabled
                                  ? Colors.red.withOpacity(0.25)
                                  : const Color(0xFF7C4DFF).withOpacity(0.3),
                              blurRadius: 60,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                        child: Icon(
                          isMicEnabled ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
