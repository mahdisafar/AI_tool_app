import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Aiapi {
  // ArvanCloud
  static String get baseUrlarvnqwen3 => dotenv.env['BASE_URL_ARV_QWEN3'] ?? '';
  static String get apikeyArvan => dotenv.env['API_KEY_ARV'] ?? '';

  // GapGPT
  static String get baseUrlGapGpt => dotenv.env['GAPGPT_BASE_URL'] ?? '';
  static String get apikeyGapGpt => dotenv.env['GAPGPT_API_KEY'] ?? '';
  static String get gapGptModelQwen =>
      dotenv.env['GAPGPT_MODEL_QWEN'] ?? 'gapgpt-qwen-3.5';

  // Hugging Face
  static String get hFBASEURL => dotenv.env['HF_BASE_URL'] ?? '';
  static String get hFAPIKEY => dotenv.env['HF_API_KEY'] ?? '';
  static String get hfModelId =>
      dotenv.env['HF_MODEL_ID'] ?? 'Qwen/Qwen2.5-7B-Instruct';

  // LiveKit
  static String get livekitBackendUrl =>
      dotenv.env['LIVEKIT_BACKEND_URL'] ?? '';
  static String get livekitUrl => dotenv.env['LIVEKIT_URL'] ?? '';
  static String get livekitTestToken => dotenv.env['LIVEKIT_TEST_TOKEN'] ?? '';

  // Endpoints & Paths
  static const String apikeyArvanchat = "/chat/completions";

  // System Prompts
  static String get makeTaskSystemPrompt =>
      dotenv.env['MAKETASK_SYSTEM_PROMPT'] ?? '';
  static String get cleanMessageSystemPrompt =>
      dotenv.env['CLEAN_MESSAGE_SYSTEM_PROMPT'] ?? '';
}

class AiNames {
  static final String? hFMODELID = dotenv.env['HF_MODEL_ID'];
  static final String arvanqwen3 = "Qwen3-30B-A3B-lom4k";
  static String get gapgptqwen3 => Aiapi.gapGptModelQwen;
}

class Prompts {
  static final String? maketask = dotenv.env['MAKETASK_SYSTEM_PROMPT'];
  static final String cleanMessage =
      dotenv.get('CLEAN_MESSAGE_SYSTEM_PROMPT').replaceAll(r'\n', '\n');
}

class Constants {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color hardBlue = Color(0xFF0A1128);
  static const Color mediumBlue = Color(0xFF1A237E);

  static const Color boxColor = Color(0xFFE3F2FD);

  static Color blackColor = const Color(0xFF1A237E).withOpacity(0.7);

  static const Color accentColor = Color(0xFF0D47A1);

  static const Color backcolor = Color(0xFFF5F9FF);

  static final Color glasscolor = Colors.white.withOpacity(0.2);

  static const Color solidGlassColor = Color(0xFFD1E3F5);
}

class AllinOnboardModel {
  String imgStr;
  String description;
  String titlestr;
  AllinOnboardModel(this.imgStr, this.description, this.titlestr);
}
