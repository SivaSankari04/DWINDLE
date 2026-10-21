import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'meter_data.dart';


class UsageChart extends StatelessWidget {
  final List<MeterData> data;
  UsageChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate daily max and min PT values to get daily consumption
    final dailyMax = <String, double>{};
    final dailyMin = <String, double>{};
    
    for (var d in data) {
      final day = "${d.timestamp.year}-${d.timestamp.month.toString().padLeft(2, '0')}-${d.timestamp.day.toString().padLeft(2, '0')}";
      
      // Track max and min PT for each day
      if (!dailyMax.containsKey(day) || d.pt > dailyMax[day]!) {
        dailyMax[day] = d.pt;
      }
      if (!dailyMin.containsKey(day) || d.pt < dailyMin[day]!) {
        dailyMin[day] = d.pt;
      }
    }
    
    // Calculate daily consumption (kWh) = (max - min) / 1000
    final chartData = dailyMax.entries.map((e) {
      final dayKey = e.key;
      final maxPt = e.value;
      final minPt = dailyMin[dayKey] ?? maxPt;
      final consumptionKwh = (maxPt - minPt) / 1000.0;
      final emissionKgCo2 = consumptionKwh * 0.85; // CO2 per kWh
      
      return _BarData(dayKey, consumptionKwh, emissionKgCo2);
    }).toList();

    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Daily Usage and Emission'),
        tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_BarData, String>>[
                ColumnSeries<_BarData, String>(
                  dataSource: chartData,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.pt,
                  name: 'Usage (kWh)',
                  color: Colors.blue,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                    dataLabelMapper: (d, _) => "${d.pt.toStringAsFixed(2)} kWh\n${d.emission.toStringAsFixed(2)} kg CO₂"

                ),
                ColumnSeries<_BarData, String>(
                  dataSource: chartData,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.emission,
                  name: 'Emission (kg CO₂)',
                  color: Colors.green,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String day;
  final double pt;
  final double emission;
  _BarData(this.day, this.pt, this.emission);
}
