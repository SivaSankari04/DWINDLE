import 'package:flutter/material.dart';
import 'waqi_service.dart';

class WaqiDisplay extends StatefulWidget {
  final String apiKey;
  final String city;

  const WaqiDisplay({required this.apiKey, required this.city, Key? key}) : super(key: key);

  @override
  State<WaqiDisplay> createState() => _WaqiDisplayState();
}

class _WaqiDisplayState extends State<WaqiDisplay> {
  late Future<int?> _aqiFuture;

  @override
  void initState() {
    super.initState();
    final waqiService = WaqiService(widget.apiKey);
    _aqiFuture = waqiService.fetchAQI(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _aqiFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final aqi = snapshot.data ?? 0;
        String quality;
        Color color;

        if (aqi <= 50) {
          quality = "Good";
          color = Colors.green;
        } else if (aqi <= 100) {
          quality = "Moderate";
          color = Colors.yellow;
        } else if (aqi <= 150) {
          quality = "Unhealthy for Sensitive Groups";
          color = Colors.orange;
        } else if (aqi <= 200) {
          quality = "Unhealthy";
          color = Colors.red;
        } else if (aqi <= 300) {
          quality = "Very Unhealthy";
          color = Colors.purple;
        } else {
          quality = "Hazardous";
          color = Colors.brown;
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('AQI: $aqi - $quality',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        );
      },
    );
  }
}
