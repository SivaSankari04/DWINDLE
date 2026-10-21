import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PreviousMonthsPage extends StatelessWidget {
  const PreviousMonthsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final previousMonths = [

      {
        "month": "March 2026",
        "target": 120.0,
        "usage": 145.0,
        "bill": 325.0,
        "carbon": 18.5,
        "status": "Paid",
        "paymentDate": "28-04-2026",
      },

      {
        "month": "April 2026",
        "target": 100.0,
        "usage": 82.0,
        "bill": 100.0,
        "carbon": 11.2,
        "status": "Paid",
        "paymentDate": "28-05-2026",
      },
    ];

    return Scaffold(

      appBar: AppBar(
        title: const Text("Previous Months Usage"),
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

              // ---------- GRAPH CARD ----------

              Container(

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Monthly Consumption Comparison",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const SizedBox(height: 10),

                    // ---------- BAR GRAPH ----------

                    SizedBox(

                      height: 260,

                      child: BarChart(

                        BarChartData(

                          alignment:
                          BarChartAlignment.spaceAround,

                          maxY: 180,

                          gridData:
                          FlGridData(show: true),

                          borderData:
                          FlBorderData(show: false),

                          titlesData: FlTitlesData(

                            leftTitles: AxisTitles(

                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),

                            rightTitles: AxisTitles(
                              sideTitles:
                              SideTitles(showTitles: false),
                            ),

                            topTitles: AxisTitles(
                              sideTitles:
                              SideTitles(showTitles: false),
                            ),

                            bottomTitles: AxisTitles(

                              sideTitles: SideTitles(

                                showTitles: true,

                                getTitlesWidget:
                                    (value, meta) {

                                  switch (value.toInt()) {

                                    case 0:
                                      return const Padding(
                                        padding:
                                        EdgeInsets.only(top: 8),
                                        child: Text("March"),
                                      );

                                    case 1:
                                      return const Padding(
                                        padding:
                                        EdgeInsets.only(top: 8),
                                        child: Text("April"),
                                      );
                                  }

                                  return const Text("");
                                },
                              ),
                            ),
                          ),

                          barGroups: [

                            // ---------- MARCH ----------

                            BarChartGroupData(

                              x: 0,

                              barsSpace: 4,

                              barRods: [

                                BarChartRodData(

                                  toY: 145,

                                  width: 35,

                                  borderRadius:
                                  BorderRadius.circular(8),

                                  color: Colors.blue,
                                ),
                              ],
                            ),

                            // ---------- APRIL ----------

                            BarChartGroupData(

                              x: 1,

                              barsSpace: 4,

                              barRods: [

                                BarChartRodData(

                                  toY: 82,

                                  width: 35,

                                  borderRadius:
                                  BorderRadius.circular(8),

                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- MONTH CARDS ----------

              ListView.builder(

                shrinkWrap: true,

                physics:
                const NeverScrollableScrollPhysics(),

                itemCount: previousMonths.length,

                itemBuilder: (context, index) {

                  final item = previousMonths[index];

                  double usage =
                  item["usage"] as double;

                  double target =
                  item["target"] as double;

                  double progress =
                      usage / target;

                  bool exceeded =
                      usage > target;

                  return Container(

                    margin:
                    const EdgeInsets.only(bottom: 20),

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color:
                      Colors.white.withOpacity(0.9),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(

                          item["month"].toString(),

                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ---------- PROGRESS BAR ----------

                        ClipRRect(

                          borderRadius:
                          BorderRadius.circular(10),

                          child:
                          LinearProgressIndicator(

                            value: progress > 1
                                ? 1
                                : progress,

                            minHeight: 18,

                            backgroundColor:
                            Colors.grey.shade300,

                            valueColor:
                            AlwaysStoppedAnimation(

                              exceeded
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        buildInfoRow(
                          "Target",
                          "${target.toStringAsFixed(0)} Units",
                        ),

                        buildInfoRow(
                          "Consumed",
                          "${usage.toStringAsFixed(0)} kWh",
                        ),

                        buildInfoRow(
                          "Estimated Bill",
                          "₹${item["bill"]}",
                        ),

                        buildInfoRow(
                          "Carbon Emission",
                          "${item["carbon"]} kg CO₂",
                        ),

                        buildInfoRow(
                          "Bill Status",
                          item["status"].toString(),
                        ),

                        buildInfoRow(
                          "Payment Date",
                          item["paymentDate"].toString(),
                        ),

                        const SizedBox(height: 16),

                        // ---------- STATUS BADGE ----------

                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(

                            color:
                            item["status"] == "Paid"
                                ? Colors.green.shade100
                                : Colors.orange.shade100,

                            borderRadius:
                            BorderRadius.circular(30),
                          ),

                          child: Text(

                            item["status"].toString(),

                            style: TextStyle(

                              color:
                              item["status"] == "Paid"
                                  ? Colors.green
                                  : Colors.orange,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ---------- TARGET STATUS ----------

                        Row(

                          children: [

                            Icon(

                              exceeded
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle,

                              color:
                              exceeded
                                  ? Colors.red
                                  : Colors.green,
                            ),

                            const SizedBox(width: 10),

                            Text(

                              exceeded
                                  ? "Target exceeded"
                                  : "Within target",

                              style: TextStyle(

                                color:
                                exceeded
                                    ? Colors.red
                                    : Colors.green,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(
      String title,
      String value,
      ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 12),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}