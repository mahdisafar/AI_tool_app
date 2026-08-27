import 'dart:io';
import 'package:ai_app/core/di/config.dart';
import 'package:ai_app/features/feature_chat/data/data_source/chat_archive_hive.dart'; 
import 'package:ai_app/features/feature_chat/data/models/local/chat_archive_local_model.dart';
import 'package:ai_app/features/feature_chat/presentation/bloc/active_chat_cubit.dart';
import 'package:ai_app/features/feature_chat/presentation/bloc/feature_chat_bloc.dart';
import 'package:ai_app/features/feature_clean_massges/data/datasources/cln_hive.dart';
import 'package:ai_app/features/feature_clean_massges/data/models/remote/cln_mg_adapter.dart';
import 'package:ai_app/features/feature_clean_massges/data/models/remote/cln_mg_list_adapter_model.dart';
import 'package:ai_app/features/feature_clean_massges/presentation/bloc/feature_clean_massges_bloc.dart';
import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/local/maketask_localmodel.dart';
import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/local/task_list_local_model.dart';
import 'package:ai_app/features/feature_maketaks/data/models/maketask_model/remote/task_list_adapter_model.dart';
import 'package:ai_app/features/feature_maketaks/presentation/bloc/feature_tasks_bloc.dart';
import 'package:ai_app/features/feature_voice_chat/presentation/bloc/feature_voice_chat_bloc.dart';
import 'package:ai_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:path_provider/path_provider.dart';
import 'config/routs/approuter.dart';
import 'features/feature_chat/data/models/local/chat_message_local_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  
  Hive.registerAdapter(MaketaskLocalModelAdapter());
  Hive.registerAdapter(TaskListLocalModelAdapter());
  Hive.registerAdapter(ClnMgListAdapterModel());
  Hive.registerAdapter(ClnMgAdapter());
  Hive.registerAdapter(ChatMessageLocalModelAdapter());
  Hive.registerAdapter(ChatArchiveLocalModelAdapter());

  
  await dotenv.load(fileName: "assets/config.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  configureDependencies();

  
  await getIt<ChatArchiveHive>()
      .openBox(); 
  await getIt<ClnHive>().openBox();

  
  await Hive.openBox<TaskListLocalModel>('task_lists_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeatureTasksBloc>(
          create: (context) => getIt<FeatureTasksBloc>(),
        ),
        BlocProvider<FeatureCleanMassgesBloc>(
          create: (context) => getIt<FeatureCleanMassgesBloc>(),
        ),
        BlocProvider<FeatureChatBloc>(
          create: (context) => getIt<FeatureChatBloc>(),
        ),
        BlocProvider<FeatureAllChatArchicesbloc>(
          create: (context) => getIt<FeatureAllChatArchicesbloc>(),
        ),
        BlocProvider<ActiveChatCubit>(
            create: (context) => getIt<ActiveChatCubit>()),
        BlocProvider<FeatureVoiceChatBloc>(
            create: (context) => getIt<FeatureVoiceChatBloc>()),
      ],
      child: MaterialApp.router(
        title: 'AI Language App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          fontFamily: 'IranYekan',
          brightness: Brightness.dark,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
