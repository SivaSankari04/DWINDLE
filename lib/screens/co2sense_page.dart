import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class CO2SensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF9F1),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(
            "My footprint",
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Text(
                "17.4",
                style: TextStyle(
                    fontSize: 46,
                    color: Color(0xFF339966),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Text("ton CO₂/yr", style: TextStyle(fontSize: 20)),
            ],
          ),

          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 18),
              Text("+5% per month", style: TextStyle(color: Colors.green)),
            ],
          ),

          SizedBox(height: 18),

          Container(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),

                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 12),
                      FlSpot(1, 13),
                      FlSpot(2, 14),
                      FlSpot(3, 15),
                      FlSpot(4, 16),
                      FlSpot(5, 14.5),
                      FlSpot(6, 15.2),
                      FlSpot(7, 16.1),
                      FlSpot(8, 17),
                      FlSpot(9, 17.4),
                      FlSpot(10, 16.8),
                      FlSpot(11, 17.4),
                    ],
                    isCurved: true,
                    barWidth: 3,
                    color: Color(0xFF339966),
                    dotData: FlDotData(show: false),
                  ),
                ],

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) {
                        const months = [
                          'Jan','Feb','Mar','Apr','May','Jun',
                          'Jul','Aug','Sep','Oct','Nov','Dec'
                        ];

                        if (v.toInt() >= 0 && v.toInt() < months.length) {
                          return Text(
                            months[v.toInt()],
                            style: TextStyle(fontSize: 12),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),

                  leftTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  topTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(blurRadius: 4, color: Colors.grey.shade200)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Footprint per category",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                SizedBox(height: 14),

                SizedBox(
                  height: 120,
                  width: 120,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                            value: 6.5,
                            color: Color(0xFF339966),
                            title: "6.5t",
                            radius: 32),
                        PieChartSectionData(
                            value: 5.2,
                            color: Color(0xFF56AB91),
                            title: "5.2t",
                            radius: 28),
                        PieChartSectionData(
                            value: 3.3,
                            color: Color(0xFFFFB84C),
                            title: "3.3t",
                            radius: 28),
                        PieChartSectionData(
                            value: 2.1,
                            color: Color(0xFFAA4465),
                            title: "2.1t",
                            radius: 24),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 24,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Indicator(color: Color(0xFF339966), text: "6.5 ton"),
                    SizedBox(width: 6),
                    Indicator(color: Color(0xFF56AB91), text: "5.2 ton"),
                    SizedBox(width: 6),
                    Indicator(color: Color(0xFFFFB84C), text: "3.3 ton"),
                    SizedBox(width: 6),
                    Indicator(color: Color(0xFFAA4465), text: "2.1 ton"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}