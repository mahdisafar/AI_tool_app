import 'dart:ui';

import 'package:ai_app/core/constants/constant.dart';
import 'package:ai_app/core/constants/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feature_chat_bloc.dart';

class ChatInputBar extends StatefulWidget {
  final ScrollController scrollController;
  const ChatInputBar({super.key, required this.scrollController});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<double> _marginNotifier = ValueNotifier<double>(0.0);
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_marginNotifier.value == 0.0) {
      _marginNotifier.value = context.width * 0.8;
    }
  }


  void _onFocus() {
    _marginNotifier.value =
        _focusNode.hasFocus ? context.width * 0.8 : context.width * 0.67;
  }

  void _scrollToBottom() {
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (widget.scrollController.hasClients) {
        final target = widget.scrollController.position.minScrollExtent;
        

        widget.scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    widget.scrollController.removeListener(_onFocus);
    _focusNode.dispose();
    _controller.dispose();
    _marginNotifier.dispose();
    super.dispose();
  }

  
  
  void _sendMessage(String? currentChatId) {
    
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (!mounted) return;

    FocusScope.of(context).unfocus();

    if (currentChatId == null) {
      
      context.read<FeatureChatBloc>().add(Createchat(message: text, image: ""));
    } else {
      context.read<FeatureChatBloc>().add(
          MessageSent(chatArchives: currentChatId, message: text, image: ""));
    }

    _controller.value = TextEditingValue.empty;
  }

  void _stopMessage() {
    if (!mounted) return;
    context.read<FeatureChatBloc>().add(StopRes());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _marginNotifier,
        builder: (context, marginvalue, child) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _marginNotifier.value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                
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
              child: BlocBuilder<FeatureChatBloc, ChatState>(
                builder: (context, state) {
                  final isGenerating = state.status == ChatStatus.streaming ||
                      state.status == ChatStatus.streamloading;

                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTapOutside: (event) {
                            _focusNode.unfocus();
                          },
                          minLines: 1,
                          maxLines: 5,
                          focusNode: _focusNode,
                          controller: _controller,
                          enabled: !isGenerating,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: isGenerating
                                ? 'AI is typing...'
                                : 'Type a message...',
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 10.0,
                            ),
                          ),
                          
                          onSubmitted: (_) {
                            if (!isGenerating) {
                              _sendMessage(state.chatId);
                              _scrollToBottom();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isGenerating)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Constants.boxColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(), 
                            icon: Icon(
                              Icons.stop_rounded,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            iconSize: 22,
                            onPressed: _stopMessage,
                          ),
                        )
                      else
                        Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF0A1128).withOpacity(0.6),
                                blurRadius: 25, 
                                spreadRadius: 2, 
                                offset: Offset(0, 4),
                              ),
                            ],
                            color: Constants.backcolor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Constants.accentColor,
                            ),
                            iconSize: 24,
                            onPressed: () {
                              _sendMessage(state.chatId);
                              _scrollToBottom();
                            },
                          ),
                        ),
                    ],
                  );
                },
              ));
        });
  }
}
