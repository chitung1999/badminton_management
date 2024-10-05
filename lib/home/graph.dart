import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  const Graph({super.key, required this.data});

  final Map<String, int> data;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<String> _key = [];

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
  void initState() {
    _key = widget.data.keys.toList();
    super.initState();
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
                widget.data[_key[groupIndex]].toString(),
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
        backgroundColor: const Color(0xFF311B92).withOpacity(0.1),
        maxY: max() * 1.2,
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
          _key[index],
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
          toY: widget.data[_key[index]]! < 0 ? 0 : widget.data[_key[index]]!.toDouble(),
          width: 40,
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          gradient: const LinearGradient(
            colors: [Color(0xff2193b0), Color(0xfff5af19)],
            stops: [0, 1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        )
      ],
      showingTooltipIndicators: [0],
    )
  );
}
