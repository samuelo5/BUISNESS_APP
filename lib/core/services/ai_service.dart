import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:business_assistant/core/constants/app_constants.dart';

class AiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-flash-latest',
    apiKey: _apiKey,
  );




  /// Generates social media content based on topic, platform, and tone.
  Future<String> generateSocialContent({
    required String topic,
    required String platform,
    required String tone,
  }) async {
    final prompt = '''
      You are a professional social media manager and marketing expert. 
      Generate a high-quality, engaging social media post for a business called "${AppConstants.appName}".
      
      TOPIC: $topic
      PLATFORM: $platform
      TONE: $tone
      
      Requirements:
      - Make it catchy and professional.
      - Include relevant emojis.
      - Include 3-5 relevant hashtags.
      - Format it ready to be copied and pasted.
      - DO NOT include placeholders like [Your Name]. Use the business name "${AppConstants.appName}" if needed.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Sorry, I couldn't generate content at this time.";
    } catch (e) {
      return 'Error generating content: $e';
    }
  }

  /// Generates a professional reply to a customer message.
  Future<String> generateCustomerReply({
    required String customerMessage,
    required String type,
  }) async {
    final prompt = '''
      You are a professional customer support assistant for a business called "${AppConstants.appName}".
      Generate a professional, polite, and helpful reply to the following customer message.
      
      CUSTOMER MESSAGE: "$customerMessage"
      MESSAGE CATEGORY: $type
      
      Requirements:
      - Tone: Professional yet friendly.
      - Goal: Resolve the customer's query or acknowledge their feedback effectively.
      - Keep it concise but thorough.
      - DO NOT include placeholders like [Insert Name]. Use "${AppConstants.appName} Team" as the signature.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Sorry, I couldn't generate a reply at this time.";
    } catch (e) {
      return 'Error generating reply: $e';
    }
  }

  /// Generates a personalized daily business tip.
  Future<String> generateDailyTip({
    required String businessName,
    required String businessType,
  }) async {
    final prompt = '''
      You are an expert business coach and strategist. 
      Provide ONE high-impact, actionable business tip for a business named "$businessName" in the "$businessType" industry.
      
      Requirements:
      - The tip must be specific to the industry: $businessType.
      - Keep it concise (max 2-3 sentences).
      - Focus on growth, efficiency, or customer retention.
      - Start with an appropriate emoji.
      - DO NOT use generic advice. Make it feel like it's from a top-tier consultant.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Focus on providing exceptional value to your customers today. Consistency is key to long-term growth.";
    } catch (e) {
      return "Tip of the day: High-quality service is your best marketing strategy. Focus on excellence.";
    }
  }
}

