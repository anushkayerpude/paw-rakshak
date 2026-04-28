import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const _apiKey = 'AIzaSyBHmhogE3CEXZufDplcCp5DSt29ZLMf0FI';

  static Future<String> getFirstAid({
    required String species,
    required String symptoms,
  }) async {
    try {
      final url = Uri.parse(
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey"
);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'You are an emergency animal first aid assistant in India. A $species has been found: $symptoms\n\nReply in this exact format:\n\nDO THIS NOW:\n- step 1\n- step 2\n- step 3\n\nDO NOT DO THIS:\n- warning 1\n- warning 2\n\nTELL THE VET:\none sentence\n\nBe simple and clear.'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        print("API WORKED");
        print('Status: ${response.statusCode}');
        print('Body: ${response.body}');
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Gemini error: ${response.statusCode} ${response.body}');
        return _fallback(species);
        print("API FAILED");
      }
    } catch (e) {
      print('Error: $e');
      return _fallback(species);
    }
  }

  static String _fallback(String species) {
    return '''DO THIS NOW:
- Keep the $species warm and calm
- Give water slowly with a dropper
- Cover any wounds with clean cloth
- Stay with the animal

DO NOT DO THIS:
- Give human medicine
- Force feed food
- Leave alone

TELL THE VET:
$species found injured on street, symptoms started recently.''';
  }
}