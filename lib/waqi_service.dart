import 'dart:convert';
import 'package:http/http.dart' as http;

class WaqiService {
  final String apiKey;
  WaqiService(this.apiKey);

  Future<int?> fetchAQI(String cityPath) async {
    final url = Uri.parse('https://api.waqi.info/feed/$cityPath/?token=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'ok') {
        return jsonData['data']['aqi'] as int?;
      } else {
        throw Exception('API returned error status');
      }
    } else {
      throw Exception('Failed to fetch AQI from API');
    }
  }
}
