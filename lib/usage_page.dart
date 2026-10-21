import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adafruit_service.dart';
import 'meter_data.dart';
import 'previous_months_page.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({super.key});

  @override
  State<UsagePage> createState() => _UsagePageState();
}

class _UsagePageState extends State<UsagePage> {

  final adafruit = AdafruitService(
    'SRIEMS',
    'ENTER_ADAFRUIT_IO_KEY',
  );

  List<MeterData> liveData = [];

  Timer? timer;

  bool isLoading = true;

  double today = 0;
  double yesterday = 0;
  double monthTotal = 0;

  double monthlyTarget = 0;

  bool isTargetSet = false;

  int touchedIndex = -1;

  String? lastMonth;

  @override
  void initState() {
    super.initState();

    fetchData();

    timer = Timer.periodic(
      const Duration(minutes: 1),
          (_) {
        fetchData();
      },
    );

    loadTarget();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ---------------- FETCH ----------------

  Future<void> fetchData() async {

    final data = await adafruit.fetchFeedData('ch2');

    setState(() {
      liveData = data;
      isLoading = false;
    });
  }

  // ---------------- TARGET ----------------

  Future<void> loadTarget() async {

    final prefs = await SharedPreferences.getInstance();

    String currentMonth =
        "${DateTime.now().year}-${DateTime.now().month}";

    if (prefs.getString("month") == currentMonth) {

      monthlyTarget =
          prefs.getDouble("target") ?? 0;

      isTargetSet = true;
    }
  }

  Future<void> saveTarget(double value) async {

    final prefs = await SharedPreferences.getInstance();

    String currentMonth =
        "${DateTime.now().year}-${DateTime.now().month}";

    await prefs.setDouble("target", value);

    await prefs.setString("month", currentMonth);

    setState(() {

      monthlyTarget = value;

      isTargetSet = true;
    });
  }

  // ---------------- CALCULATIONS ----------------

  void calculate() {

    if (liveData.isEmpty) return;

    DateTime now = DateTime.now();

    DateTime yesterdayStart =
    DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));

    String currentMonth =
        "${now.year}-${now.month}";

    if (lastMonth != null &&
        lastMonth != currentMonth) {

      monthTotal = 0;
    }

    lastMonth = currentMonth;

    // ---------- TODAY ----------

    double todayMax = 0;
    double todayMin = double.infinity;

    for (var d in liveData) {

      if (d.timestamp.year == now.year &&
          d.timestamp.month == now.month &&
          d.timestamp.day == now.day) {

        if (d.pt > todayMax) {
          todayMax = d.pt;
        }

        if (d.pt < todayMin) {
          todayMin = d.pt;
        }
      }
    }

    today = todayMin == double.infinity
        ? 0
        : (todayMax - todayMin) / 1000;

    // ---------- YESTERDAY ----------

    double yesterdayMax = 0;
    double yesterdayMin = double.infinity;

    for (var d in liveData) {

      if (d.timestamp.year ==
          yesterdayStart.year &&
          d.timestamp.month ==
              yesterdayStart.month &&
          d.timestamp.day ==
              yesterdayStart.day) {

        if (d.pt > yesterdayMax) {
          yesterdayMax = d.pt;
        }

        if (d.pt < yesterdayMin) {
          yesterdayMin = d.pt;
        }
      }
    }

    yesterday = yesterdayMin == double.infinity
        ? 0
        : (yesterdayMax - yesterdayMin) / 1000;

    // ---------- MONTH TOTAL ----------

    Map<String, double> dailyMax = {};
    Map<String, double> dailyMin = {};

    for (var d in liveData) {

      if (d.timestamp.month == now.month &&
          d.timestamp.year == now.year) {

        String key =
            "${d.timestamp.year}-${d.timestamp.month}-${d.timestamp.day}";

        double val = d.pt;

        if (!dailyMax.containsKey(key) ||
            val > dailyMax[key]!) {

          dailyMax[key] = val;
        }

        if (!dailyMin.containsKey(key) ||
            val < dailyMin[key]!) {

          dailyMin[key] = val;
        }
      }
    }

    monthTotal = 0;

    dailyMax.forEach((key, max) {

      double min = dailyMin[key] ?? max;

      double dailyConsumption =
          (max - min) / 1000;

      monthTotal += dailyConsumption;
    });
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    calculate();

    double remaining =
    monthlyTarget > monthTotal
        ? monthlyTarget - monthTotal
        : 0;

    double percent = monthlyTarget == 0
        ? 0
        : (monthTotal / monthlyTarget) * 100;

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Electricity Consumption",
        ),
      ),

      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.green.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(16),

          child: Column(

            children: [

              // ---------- PIE ----------

              buildCard(

                "Usage Distribution",

                Column(

                  children: [

                    SizedBox(

                      height: 250,

                      child: PieChart(

                        PieChartData(

                          pieTouchData: PieTouchData(

                            touchCallback: (
                                event,
                                res,
                                ) {

                              setState(() {

                                touchedIndex =
                                    res
                                        ?.touchedSection
                                        ?.touchedSectionIndex ??
                                        -1;
                              });
                            },
                          ),

                          sections: [

                            section(
                              today,
                              Colors.yellow,
                              "Today",
                              0,
                            ),

                            section(
                              yesterday,
                              Colors.green,
                              "Yesterday",
                              1,
                            ),

                            section(
                              monthTotal,
                              Colors.red,
                              "Monthly",
                              2,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                      children: [

                        legend(
                          Colors.yellow,
                          "Today",
                        ),

                        legend(
                          Colors.green,
                          "Yesterday",
                        ),

                        legend(
                          Colors.red,
                          "Monthly",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- SUMMARY ----------

              buildCard(

                "Consumption Summary",

                Column(

                  children: [

                    _buildSummaryRow(
                      "Today",
                      today,
                      Colors.yellow,
                    ),

                    const SizedBox(height: 12),

                    _buildSummaryRow(
                      "Yesterday",
                      yesterday,
                      Colors.green,
                    ),

                    const SizedBox(height: 12),

                    _buildSummaryRow(
                      "March 2026 Total",
                      monthTotal,
                      Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- TARGET BUTTON ----------

              ElevatedButton(

                onPressed:
                isTargetSet
                    ? null
                    : showDialogBox,

                child: Text(

                  isTargetSet
                      ? "Target: ${monthlyTarget.toStringAsFixed(0)} Units"
                      : "Set Monthly Target",
                ),
              ),

              const SizedBox(height: 20),

              // ---------- TARGET PROGRESS ----------

              if (isTargetSet)

                buildCard(

                  "Target Progress",

                  Column(

                    children: [

                      SizedBox(

                        height: 220,

                        child: Stack(

                          alignment: Alignment.center,

                          children: [

                            PieChart(

                              PieChartData(

                                sections: [

                                  PieChartSectionData(
                                    value: monthTotal,
                                    color: Colors.blue,
                                    radius: 60,
                                    title: "",
                                  ),

                                  PieChartSectionData(
                                    value: remaining,
                                    color:
                                    Colors.grey.shade300,
                                    radius: 60,
                                    title: "",
                                  ),
                                ],
                              ),
                            ),

                            Text(

                              "${percent.toStringAsFixed(0)}%",

                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // ---------- HISTORY BUTTON ----------

              ElevatedButton.icon(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                      const PreviousMonthsPage(),
                    ),
                  );
                },

                icon: const Icon(Icons.history),

                label: const Text(
                  "View Previous Months History",
                ),

                style: ElevatedButton.styleFrom(

                  minimumSize:
                  const Size(double.infinity, 55),

                  shape: RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  PieChartSectionData section(
      double value,
      Color color,
      String label,
      int index,
      ) {

    final isTouched =
        index == touchedIndex;

    return PieChartSectionData(

      value: value,

      color: color,

      radius: isTouched ? 75 : 60,

      title: isTouched
          ? "$label\n${value.toStringAsFixed(1)} kWh"
          : "",

      titleStyle:
      const TextStyle(fontSize: 12),
    );
  }

  Widget legend(Color c, String t) {

    return Row(

      children: [

        Container(
          width: 12,
          height: 12,
          color: c,
        ),

        const SizedBox(width: 6),

        Text(t),
      ],
    );
  }

  Widget _buildSummaryRow(
      String label,
      double value,
      Color color,
      ) {

    return Row(

      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Row(

          children: [

            Container(
              width: 12,
              height: 12,
              color: color,
            ),

            const SizedBox(width: 10),

            Text(

              label,

              style:
              const TextStyle(fontSize: 16),
            ),
          ],
        ),

        Text(

          "${value.toStringAsFixed(2)} kWh",

          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildCard(
      String title,
      Widget child,
      ) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.9),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(

        children: [

          Text(

            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  void showDialogBox() {

    TextEditingController c =
    TextEditingController();

    showDialog(

      context: context,

      builder: (_) => AlertDialog(

        title: const Text(
          "Set Monthly Target",
        ),

        content: TextField(

          controller: c,

          keyboardType:
          TextInputType.number,
        ),

        actions: [

          TextButton(

            onPressed: () =>
                Navigator.pop(context),

            child: const Text("Cancel"),
          ),

          ElevatedButton(

            onPressed: () {

              double v =
                  double.tryParse(c.text) ?? 0;

              if (v > 0) {

                saveTarget(v);

                Navigator.pop(context);
              }
            },

            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}