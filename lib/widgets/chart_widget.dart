import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/glassmorphism_theme.dart';

class ChartWidget extends StatelessWidget {
  final String title;
  final ChartType type;
  final Map<String, double> data;
  final List<Color> colors;
  final double height;

  const ChartWidget({
    super.key,
    required this.title,
    required this.type,
    required this.data,
    this.colors = const [
      GlassmorphismTheme.primaryColor,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.blue,
    ],
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: height, child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (type) {
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
      case ChartType.doughnut:
        return _buildDoughnutChart();
    }
  }

  Widget _buildPieChart() {
    final entries = data.entries.toList();

    return PieChart(
      PieChartData(
        sections: entries.asMap().entries.map((entry) {
          final index = entry.key;
          final dataEntry = entry.value;
          final total = data.values.reduce((a, b) => a + b);
          final percentage = total > 0 ? (dataEntry.value / total) * 100 : 0.0;

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: dataEntry.value,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildDoughnutChart() {
    final entries = data.entries.toList();

    return PieChart(
      PieChartData(
        sections: entries.asMap().entries.map((entry) {
          final index = entry.key;
          final dataEntry = entry.value;
          final total = data.values.reduce((a, b) => a + b);
          final percentage = total > 0 ? (dataEntry.value / total) * 100 : 0.0;

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: dataEntry.value,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        centerSpaceRadius: 60,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildBarChart() {
    final entries = data.entries.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.values.isNotEmpty
            ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
            : 100,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < entries.length) {
                  final label = entries[value.toInt()].key;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      label.length > 8 ? '${label.substring(0, 8)}...' : label,
                      style: const TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: entries.asMap().entries.map((entry) {
          final index = entry.key;
          final dataEntry = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: dataEntry.value,
                color: colors[index % colors.length],
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  Widget _buildLineChart() {
    final entries = data.entries.toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < entries.length) {
                  final label = entries[value.toInt()].key;
                  return Text(
                    label.length > 6 ? '${label.substring(0, 6)}...' : label,
                    style: const TextStyle(
                      color: GlassmorphismTheme.textSecondaryColor,
                      fontSize: 10,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        minX: 0,
        maxX: (entries.length - 1).toDouble(),
        minY: 0,
        maxY: data.values.isNotEmpty
            ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
            : 100,
        lineBarsData: [
          LineChartBarData(
            spots: entries.asMap().entries.map((entry) {
              final index = entry.key;
              final dataEntry = entry.value.value;
              return FlSpot(index.toDouble(), dataEntry);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                GlassmorphismTheme.primaryColor.withOpacity(0.8),
                GlassmorphismTheme.primaryColor.withOpacity(0.3),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  GlassmorphismTheme.primaryColor.withOpacity(0.3),
                  GlassmorphismTheme.primaryColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ChartType { pie, bar, line, doughnut }

class MiniChartWidget extends StatelessWidget {
  final String title;
  final double value;
  final double previousValue;
  final IconData icon;
  final Color color;

  const MiniChartWidget({
    super.key,
    required this.title,
    required this.value,
    required this.previousValue,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final change = value - previousValue;
    final changePercent = previousValue > 0
        ? (change / previousValue) * 100
        : 0.0;
    final isPositive = change >= 0;

    return GlassmorphismTheme.glassmorphismContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: GlassmorphismTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: const TextStyle(
              color: GlassmorphismTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${changePercent.abs().toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
