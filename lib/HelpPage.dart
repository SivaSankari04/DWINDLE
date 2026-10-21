import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

class HelpPage extends StatelessWidget {

  final double electricityUsage;
  final double carbonFootprint;

  const HelpPage({
    super.key,
    required this.electricityUsage,
    required this.carbonFootprint,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF339966),
        tooltip: "Ask Dwindle Assistant",
        child: const Icon(Icons.android, size: 40),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                electricityUsage: electricityUsage,
                carbonFootprint: carbonFootprint,
              ),
            ),
          );
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA5D6A7), Color(0xFF81C784)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Dwindle",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Dwindle helps you monitor electricity usage with real-time insights and smart recommendations.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "1️⃣ Connect your smart meter\n"
                        "2️⃣ Track your daily,weekly,monthly usage\n"
                        "3️⃣ Save energy with AI tips",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 FAQ TITLE
            _sectionTitle("Frequently Asked Questions"),

            const SizedBox(height: 10),

            /// FAQ ITEMS
            _buildFAQ(
              "Why is my usage high?",
              "Check appliances running continuously. Devices like AC, heaters, and refrigerators consume more power.",
            ),

            _buildFAQ(
              "How does Dwindle calculate my bill?",
              "It uses your electricity usage and local tariff rates to estimate your bill.",
            ),

            _buildFAQ(
              "Can I use Dwindle without Wi-Fi?",
              "No, Wi-Fi is required to fetch real-time data from your smart meter.",
            ),

            _buildFAQ(
              "How often does data update?",
              "Your usage updates every few minutes automatically.",
            ),

            _buildFAQ(
                "What do the AQI colors indicate?",
                "Air Quality Index (AQI) uses colors to show how polluted the air is:\n\n"
                    "🟢 Green – Good (0–50): Air is clean and safe.\n"
                    "🟡 Yellow – Moderate (51–100)\n"
                    "🟠 Orange – Harmful (101–150)\n"
                    "🔴 Red – Unhealthy (151–200)\n"
                    "🟣 Purple – Very Unhealthy (201–300)\n"
                    "🟤 Maroon – Hazardous (301+)"
            ),

            const SizedBox(height: 25),

            /// 🔹 TROUBLESHOOTING
            _sectionTitle("Troubleshooting"),

            _buildCard([
              "Ensure your smart meter is powered on",
              "Check Wi-Fi connection",
              "Restart the app if data is not loading",
            ]),

            const SizedBox(height: 25),

            /// 🔹 NEED HELP
            _sectionTitle("📞 Need Help?"),

            _buildCard([
              "📩 dwindle.energy@gmail.com",
              "💬 Chat with our AI assistant for instant support and energy insights.",
            ]),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "⚡ Together, let’s make energy smarter!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.green.shade800,
      ),
    );
  }

  /// 🔹 Card Builder
  Widget _buildCard(List<String> points) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: points
            .map((text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(text),
        ))
            .toList(),
      ),
    );
  }

  /// 🔹 FAQ Widget
  Widget _buildFAQ(String question, String answer) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(answer),
          )
        ],
      ),
    );
  }
}