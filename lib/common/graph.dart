import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  const Graph({super.key, required this.data});

  final Map<String, int> data;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  double max() {
    int max = 0;
    widget.data.forEach((key, value) {
      if (value > max) {
        max = value;
      }
    });
    return max.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 8,
            getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
                ) {
              return BarTooltipItem(
                widget.data.values.elementAt(groupIndex).toString(),
                const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: getTitles,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.deepPurple)),
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        backgroundColor: Colors.black12.withOpacity(0.04),
        maxY: max() * 1.2,
      ),
      duration: const Duration(seconds: 0),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
          widget.data.keys.elementAt(index),
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )
      ),
    );
  }

  List<BarChartGroupData> get barGroups => List.generate(
      widget.data.length, (index) => BarChartGroupData(
    x: index,
    barRods: [
      BarChartRodData(
        toY: widget.data.values.elementAt(index) < 0 ? 0 : widget.data.values.elementAt(index).toDouble(),
        width: 40,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.indigo.shade400],
          stops: const [0, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
    ],
    showingTooltipIndicators: [0],
  )
  );
}
