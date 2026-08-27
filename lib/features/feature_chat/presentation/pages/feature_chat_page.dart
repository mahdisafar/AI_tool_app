import 'package:ai_app/config/routs/approuting.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constant.dart';
import '../bloc/feature_chat_bloc.dart';
import '../widgets/chat_drawer.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_list.dart';

class FeatureChatPage extends StatefulWidget {
  const FeatureChatPage({super.key});

  @override
  State<FeatureChatPage> createState() => _FeatureChatPageState();
}

class _FeatureChatPageState extends State<FeatureChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.read<FeatureAllChatArchicesbloc>().add(GetAllchatArchives());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const ChatDrawer(),
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
            stops: [0.0, 0.08, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, 
                      Colors.black, 
                      Colors.black, 
                      Colors.transparent, 
                    ],
                    stops: [
                      0.0, 
                      0.07, 
                      0.85, 
                      0.98, 
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: ChatMessageList(
                  scrollController: _scrollController,
                ),
              ),

              
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 49,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Constants.mediumBlue.withOpacity(0.9),
                        Constants.mediumBlue.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A1128).withOpacity(0.6),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'AI Chat',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                      IconButton(
                        onPressed: () {
                          AppRouting.back(context);
                        },
                        icon: const Icon(Icons.backspace, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),

              
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ChatInputBar(
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
