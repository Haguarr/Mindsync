import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String _apiKey = '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'; // Your API key
  static const String _endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          // Temporarily remove HTTP-Referer for local testing
          // 'HTTP-Referer': 'http://localhost:55901/#EchoMind',
          'X-Title': 'EchoMindApp',
        },
        body: jsonEncode({
          'model': 'xai/grok-8b:free', // Switch to Grok free model
          'messages': [
            {
              "role": "system",
              "content": "You are Echo Mind, an emotionally intelligent AI designed to provide empathetic and practical support for stress and work pressure. Respond with kindness, offer actionable advice, and maintain a supportive tone. Keep responses concise (under 100 words) and include an emoji."
            },
            {"role": "user", "content": userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('API Error - Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception Details: $e');
      return 'Sorry, an error occurred: $e. Please try again later. 😔';
    }
  }
}