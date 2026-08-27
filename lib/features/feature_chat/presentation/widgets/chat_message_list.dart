import 'package:ai_app/features/feature_chat/presentation/bloc/active_chat_cubit.dart';
import 'package:ai_app/features/feature_chat/presentation/bloc/feature_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'chat_bubble.dart';

class ChatMessageList extends StatefulWidget {
  final ScrollController scrollController;
  const ChatMessageList({super.key, required this.scrollController});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveChatCubit, String?>(listener:
        (context, currentId) {
      if (currentId != null) {
        context.read<FeatureChatBloc>().add(ResetChatEvent());
        context.read<FeatureChatBloc>().add(GetMainchatsEvent(id: currentId));
      } else if (currentId == null) {
        context.read<FeatureChatBloc>().add(CreateNewArchive());
      }
    }, child:
        BlocBuilder<FeatureChatBloc, ChatState>(builder: (context, chatState) {
      debugPrint("archiveState:  ${chatState.runtimeType}");
      if (chatState.status == ChatStatus.archiveLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (chatState.status == ChatStatus.archiveFailed) {
        return Center(child: Text("خطا در بارگذاری پیام‌ها: "));
      }
      List<ChatMessageEntity> displayMessages = [
        
        if (chatState.streamingMessage != null) chatState.streamingMessage!,
        
        ...chatState.messages,
      ];
      if (displayMessages.isEmpty) {
        return Center(child: Text(" خوش آمدید چت را شروع کنید"));
      }

      //check is userText on Begining of the List?
      return ListView.builder(
        padding: const EdgeInsets.only(
          top: 80,
          left: 12,
          right: 12,
          bottom: 110,
        ),
        controller: widget.scrollController,
        reverse: true, 
        itemCount: displayMessages.length,
        itemBuilder: (context, index) {
          final msg = displayMessages[index];
          return ChatBubble(
            text: msg.text,
            isUser: msg.isUser,
          );
        },
      );
    }));
  }
}
