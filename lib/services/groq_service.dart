import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {

  static const String apiKey = "ENTER_GROQ_API_KEY";

  static Future<String> sendMessage(
      String message,
      double electricityUsage,
      double carbonFootprint
      ) async {

    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {
            "role": "system",
            "content":
            "You are an AI assistant for an electricity monitoring app called Dwindle."
                "The user currently has electricity usage of $electricityUsage kWh and "
                "carbon footprint of $carbonFootprint kg CO2. Give helpful advice to reduce energy usage."
                "Always respond in a clear, polite, and conversational manner."
                "If the user asks something unrelated to electricity or energy usage, respond politely but guide the conversation back to energy or sustainability topics."
          },
          {
            "role": "user",
            "content": message
          }
        ],
        "temperature": 0.7,
        "max_tokens": 200
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Sorry,I couldn't connect to the AI service.";
    }
  }
}