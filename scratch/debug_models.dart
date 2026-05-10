import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');

  try {
    print('Fetching available models...');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final models = data['models'] as List;
      print('\nAvailable models:');
      for (var model in models) {
        print('- ${model['name']} (${model['displayName']})');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  } catch (e) {
    print('Failed to fetch models: $e');
  }
}
