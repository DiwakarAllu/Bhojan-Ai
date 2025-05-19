import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NutrientChart extends StatelessWidget {
  final Map<String, dynamic> nutrients;

  const NutrientChart(this.nutrients, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
        Text(
            "This pie chart represents the proportion of Carbs, Protein, Fat, and Sugar in the food item."),
       // SizedBox(height: 6),
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                    title: " ",
                    value: nutrients['carbohydrate'].toDouble(),
                    color: Colors.orange),
                PieChartSectionData(
                    title: " ",
                    value: nutrients['protein'].toDouble(),
                    color: Colors.blue),
                PieChartSectionData(
                    title: " ",
                    value: nutrients['fat'].toDouble(),
                    color: Colors.red),
                PieChartSectionData(
                    title: " ",
                    value: nutrients['sugar'].toDouble(),
                    color: Colors.purple),
              ],
              sectionsSpace: 1,
              centerSpaceRadius: 50,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      
        Wrap(
          spacing: 12,
          children: [
            _buildLegend(Colors.orange, "Carbs"),
            _buildLegend(Colors.blue, "Protein"),
            _buildLegend(Colors.red, "Fat"),
            _buildLegend(Colors.purple, "Sugar"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, color: color),
        SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
