import 'package:ai_app/config/routs/approuting.dart';
import 'package:ai_app/core/constants/constant.dart';
import 'package:ai_app/core/constants/utils/extentions.dart';
import 'package:ai_app/core/widgets/custom_showdeletedialog.dart';
import 'package:ai_app/features/feature_chat/presentation/bloc/active_chat_cubit.dart';
import 'package:ai_app/features/feature_chat/presentation/bloc/feature_chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_archives_entity.dart';

/// منوی کشویی تاریخچه چت‌ها - تبدیل به StatefulWidget برای مدیریت لود دیتا
class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  @override
  void initState() {
    super.initState();
    // 🔥 به محض اینکه دراور باز بشه، این ایونت اجرا میشه و لیست چت‌ها رو از هایو می‌کشه بیرون
    context.read<FeatureAllChatArchicesbloc>().add(GetAllchatArchives());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: context.width * 1,
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Conversation History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                        onPressed: () {
                          AppRouting.back(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: BlocBuilder<FeatureAllChatArchicesbloc,
                    AllChatArchicesState>(
                  builder: (context, state) {
                    debugPrint("وضعیت فعلی دراور: ${state.runtimeType}");

                    // 🌟 اگر در حالت اولویت یا لودینگ بود، انیمیشن لودینگ نشون بده
                    if (state is AllChatArchicesInitial ||
                        state is AllChatArchicesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is AllChatArchicesFailed) {
                      return const Center(
                        child: Text("خطا در بارگذاری تاریخچه"),
                      );
                    }

                    List<ChatArchivesEntity> archives = [];
                    if (state is AllChatArchicesSuccses) {
                      archives = state.allchat ?? [];
                    }

                    debugPrint("تعداد آیتم‌های تاریخچه: ${archives.length}");
                    if (archives.isEmpty) {
                      return const Center(
                        child: Text("تاریخچه چت خالی است"),
                      );
                    }

                    return ListView.builder(
                      itemCount: archives.length,
                      itemBuilder: (context, index) {
                        // چک کردن برای جلوگیری از کراش در صورتی که لیست چت داخل آرشیو خالی باشه
                        final chatTitle = archives[index].chat.isNotEmpty
                            ? archives[index].chat[0].text
                            : "چت خالی";

                        return ListTile(
                          leading: const Icon(Icons.chat_bubble_outline),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  chatTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  showDeleteDialog(context, onPressed: () {
                                    AppRouting.back(context);
                                    context
                                        .read<FeatureAllChatArchicesbloc>()
                                        .add(DeletechatsEvent(
                                            id: archives[index].id));
                                  });
                                },
                                icon: const Text("حذف",
                                    style: TextStyle(color: Colors.red)),
                              )
                            ],
                          ),
                          subtitle: const Text('10:00 AM'),
                          onTap: () {
                            context
                                .read<ActiveChatCubit>()
                                .selectChat(archives[index].id);
                            Navigator.pop(
                                context); // بستن دراور بعد از انتخاب چت
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('New Chat'),
                onTap: () {
                  context.read<ActiveChatCubit>().createNewChat();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
