import 'package:flutter/material.dart';
import 'adafruit_service.dart';
import 'meter_data.dart';
import 'usage_chart.dart';
import 'waqi_display.dart';
import 'package:dwindle/HelpPage.dart';
import 'package:dwindle/ReceiptsPage.dart';
import 'package:dwindle/accounts.dart';
import 'usage_page.dart';

class Co2SensePage extends StatefulWidget {
  const Co2SensePage({Key? key}) : super(key: key);

  @override
  _Co2SensePageState createState() => _Co2SensePageState();
}

class _Co2SensePageState extends State<Co2SensePage> {

  int _selectedIndex = 0;

  final adafruit = AdafruitService(
      'SRIEMS',
      'ENTER_ADAFRUIT_IO_KEY');

  void _onItemTapped(int index) {

    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
      });
    }

    else if (index == 1) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ReceiptsPage()));
    }

    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const UsagePage(),
        ),
      );
    }

    else if (index == 3) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AccountPage()));
    }

    else if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FutureBuilder<List<MeterData>>(
            future: adafruit.fetchFeedData('ch2'),
            builder: (context, snapshot) {

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {

                final data = snapshot.data!;

                double units = data.last.pt / 1000;
                double carbon = units * 0.82;

                return HelpPage(
                  electricityUsage: units,
                  carbonFootprint: carbon,
                );
              }

              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      );
    }
  }

  double calculateBill(double units) {

    double cost = 0;

    if (units <= 100) {
      cost = 0;
    }

    else if (units <= 200) {
      cost = (units - 100) * 2.25;
    }

    else if (units <= 400) {
      cost = (100 * 2.25) + (units - 200) * 4.50;
    }

    else if (units <= 500) {
      cost = (100 * 2.25) +
          (200 * 4.50) +
          (units - 400) * 6.00;
    }

    else {
      cost = (100 * 2.25) +
          (200 * 4.50) +
          (100 * 6.00) +
          (units - 500) * 8.00;
    }

    return cost;
  }

  Widget _buildCo2SenseDashboard() {

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            WaqiDisplay(
              apiKey: 'ENTER_WAQI_API_KEY',
              city: 'chennai/arumbakkam',
            ),

            const SizedBox(height: 16),

            FutureBuilder<List<MeterData>>(

              future: adafruit.fetchFeedData('ch2'),

              builder: (context, snapshot) {

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {

                  final data = snapshot.data!;

                  double watts = 0;

                  if (data.length >= 2) {
                    final latest = data.last;
                    final previous = data[data.length - 2];

                    final ptDiff = latest.pt - previous.pt;
                    final timeDiff = latest.timestamp
                        .difference(previous.timestamp)
                        .inSeconds;

                    if (timeDiff > 0) {
                      watts = (ptDiff / timeDiff) * 3600;
                    }
                  }

                  double units = data.last.pt / 1000;
                  double cost = calculateBill(units);

                  return Column(

                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [

                      SizedBox(
                        height: 260,
                        child: UsageChart(data: snapshot.data!),
                      ),

                      const SizedBox(height: 20),

                      /// ENERGY CARD
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.orange.shade400,
                            width: 2,
                          ),
                        ),

                        child: Row(
                          children: [

                            Icon(Icons.flash_on, color: Colors.orange, size: 30),
                            SizedBox(width: 16),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Energy Consumption"),

                                Text(
                                  "${watts.toStringAsFixed(0)} W",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.green.shade400,
                            width: 2,
                          ),
                        ),

                        child: Row(
                          children: [

                            Icon(Icons.currency_rupee, color: Colors.green, size: 30),
                            SizedBox(width: 16),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Estimated Cost"),

                                Text(
                                  "₹ ${cost.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }

                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Dwindle'),
      ),

      body: _buildCo2SenseDashboard(),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'CO2Sense'),

          BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Receipts'),

          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Usage'),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account'),

          BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'HELP'),
        ],
      ),
    );
  }
}