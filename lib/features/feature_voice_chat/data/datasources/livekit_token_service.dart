import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../../../../core/constants/constant.dart';

@lazySingleton
class LiveKitTokenService {
  String get _baseUrl => Aiapi.livekitBackendUrl;

  Future<http.Response> fetchToken({
    String identity = 'user_1',
    String room = 'mms',
  }) async {
    final uri = Uri.parse('$_baseUrl/token').replace(
      queryParameters: {
        'identity': identity,
        'room': room,
      },
    );

    return await http.get(uri).timeout(
          const Duration(seconds: 15),
        );
  }
}
