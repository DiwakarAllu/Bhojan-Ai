import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NutrientBarChart extends StatelessWidget {
  final Map<String, dynamic> nutrients;

  const NutrientBarChart(this.nutrients, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Nutrient Comparison",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text(
            "This bar chart compares Carbs, Protein, and Fat to highlight their relative quantities."),
        SizedBox(height: 16),

        
        Padding(
          padding: EdgeInsets.only(bottom: 16), 
          child: SizedBox(
            height: 350,
            width: 400, 
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(
                        toY: nutrients['carbohydrate'].toDouble(),
                        width: 32,
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6))
                            ),  
                  ]),
                  
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: nutrients['protein'].toDouble(),
                        width: 32, 
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6))
                        )
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(
                        toY: nutrients['fat'].toDouble(),
                        width: 32, 
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6))
                        )
                  ]),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text("Nutrient Type",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, _) {
                        switch (value.toInt()) {
                          case 0:
                            return Text("Carbs");
                          case 1:
                            return Text("Protein");
                          case 2:
                            return Text("Fat");
                          default:
                            return Text("");
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
