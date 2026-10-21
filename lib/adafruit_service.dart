import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meter_data.dart';

class AdafruitService {
  final String username;
  final String apiKey;

  AdafruitService(this.username, this.apiKey);

  Future<List<MeterData>> fetchFeedData(String feedKey) async {
    final url = 'https://io.adafruit.com/api/v2/$username/feeds/$feedKey/data';

    final response = await http.get(
      Uri.parse(url),
      headers: {'X-AIO-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) {
        final valueData = jsonDecode(json['value']);
        return MeterData(
          timestamp: DateTime.parse(json['created_at']),
          pt: _parseDouble(valueData['PT']),
          bill: _parseDouble(valueData['BILL']),
        );
      }).toList();
    } else {
      throw Exception('Failed to load feed data');
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
