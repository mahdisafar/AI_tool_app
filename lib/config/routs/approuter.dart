import 'package:ai_app/config/routs/approutes.dart';
import 'package:go_router/go_router.dart';
import '../../features/feature_chat/presentation/pages/feature_chat_page.dart';
import '../../features/feature_home/presentation/pages/home_page.dart';
import '../../features/feature_clean_massges/presentation/pages/messages.dart';
import '../../features/feature_onboarding/presentation/widgets/professionalonboarding.dart';
import '../../features/feature_maketaks/presentation/pages/tasks_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const ProfessionalOnboarding(),
      ),
      // مسیر اصلی Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            name: AppRoutes.tasksPage,
            path: "tasks_page",
            builder: (context, state) => const TasksPage(),
          ),
          GoRoute(
            name: AppRoutes.messagesPage,
            path: "messages_page",
            builder: (context, state) => const Messages(),
          ),
          GoRoute(
            name: AppRoutes.aichatPage,
            path: "AIchat_page'",
            builder: (context, state) => const FeatureChatPage(),
          ),
        ],
      ),
    ],
  );
}
