import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_adapter.dart';

class ApiAiAdapter implements AiAdapter {
  final String endpoint;
  final String apiKey;

  ApiAiAdapter({
    required this.endpoint,
    required this.apiKey,
  });

  @override
  Future<AiResponse> suggest(AiRequest request) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'input': request.userInput,
        'context': request.context,
      }),
    );

    final data = jsonDecode(response.body);

    return AiResponse(
      message: data['message'] ?? '',
      suggestion: data['suggestion'],
    );
  }
}
