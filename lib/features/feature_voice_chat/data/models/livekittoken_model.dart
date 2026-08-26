class LiveKitTokenModel {
  final String token;
  final String? livekitUrl;

  LiveKitTokenModel({
    required this.token,
    this.livekitUrl,
  });

  factory LiveKitTokenModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Server returned empty token');
    }
    return LiveKitTokenModel(
      token: token,
      livekitUrl: json['livekit_url'] as String?,
    );
  }
}
