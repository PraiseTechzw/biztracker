import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';

class ChartWidget extends StatelessWidget {
  final String title;
  final List<ChartData> data;
  final ChartType type;
  final double height;

  const ChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.type = ChartType.bar,
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
              fontWeight: FontWeight.bold,
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
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
      case ChartType.pie:
        return _buildPieChart();
    }
  }

  Widget _buildBarChart() {
    if (data.isEmpty) return _buildEmptyState();

    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final colors = [
      GlassmorphismTheme.primaryColor,
      GlassmorphismTheme.secondaryColor,
      GlassmorphismTheme.accentColor,
      Colors.green,
      Colors.orange,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final height = maxValue > 0
            ? (item.value / maxValue) * (this.height - 60.0)
            : 0.0;
        final color = colors[index % colors.length];

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: const TextStyle(
                  color: GlassmorphismTheme.textSecondaryColor,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLineChart() {
    if (data.isEmpty) return _buildEmptyState();

    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final width = 300.0;
    final height = this.height - 40;

    return CustomPaint(
      size: Size(width, height),
      painter: LineChartPainter(
        data: data,
        maxValue: maxValue,
        color: GlassmorphismTheme.primaryColor,
      ),
    );
  }

  Widget _buildPieChart() {
    if (data.isEmpty) return _buildEmptyState();

    final total = data.map((d) => d.value).reduce((a, b) => a + b);
    final colors = [
      GlassmorphismTheme.primaryColor,
      GlassmorphismTheme.secondaryColor,
      GlassmorphismTheme.accentColor,
      Colors.green,
      Colors.orange,
    ];

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomPaint(
            size: const Size(120, 120),
            painter: PieChartPainter(data: data, total: total, colors: colors),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final percentage = total > 0 ? (item.value / total) * 100 : 0;
              final color = colors[index % colors.length];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: GlassmorphismTheme.textColor,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: GlassmorphismTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            color: GlassmorphismTheme.textSecondaryColor.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'No data available',
            style: TextStyle(
              color: GlassmorphismTheme.textSecondaryColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});
}

enum ChartType { bar, line, pie }

class LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double maxValue;
  final Color color;

  LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].value / maxValue) * size.height;
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double total;
  final List<Color> colors;

  PieChartPainter({
    required this.data,
    required this.total,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = 0;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * 3.14159;
      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
