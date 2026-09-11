import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiService {
  static const _apiKey = 'AIzaSyBHmhogE3CEXZufDplcCp5DSt29ZLMf0FI';

  static Future<String> getFirstAid({
    required String species,
    required String symptoms,
  }) async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey',
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
                  'text': 'You are an emergency animal first-aid assistant in India. A $species has been found with condition: $symptoms\n\n'
                      'Reply strictly in this format (use only standard hyphens, no em-dashes):\n\n'
                      'DO THIS RIGHT NOW:\n'
                      '- Action step 1\n'
                      '- Action step 2\n'
                      '- Action step 3\n\n'
                      'DO NOT DO THIS:\n'
                      '- Safety warning 1\n'
                      '- Safety warning 2\n\n'
                      'TELL THE VET:\n'
                      'One concise sentence summary for clinic triage.',
                }
              ],
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawText = data['candidates'][0]['content']['parts'][0]['text'] as String;
        // Clean any accidental em-dashes to standard hyphens
        return rawText.replaceAll('—', '-').replaceAll('–', '-');
      } else {
        debugPrint('Gemini API status ${response.statusCode}: ${response.body}');
        return _fallback(species);
      }
    } catch (e) {
      debugPrint('Gemini Service error: $e');
      return _fallback(species);
    }
  }

  static String _fallback(String species) {
    return '''DO THIS RIGHT NOW:
- Keep the $species shaded, warm, and calm in a quiet spot.
- If spinal trauma or fracture is suspected, do not shift unnecessarily.
- Provide small sips of water via clean dropper; do not force drink.
- Cover any active lacerations with clean sterile cloth.

DO NOT DO THIS:
- Never administer human medications like paracetamol or ibuprofen.
- Do not force feed solid food.
- Do not leave the animal unattended in direct sun or high traffic.

TELL THE VET:
$species found with acute distress, symptoms noted recently on street.''';
  }
}