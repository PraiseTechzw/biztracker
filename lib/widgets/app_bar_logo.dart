import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';

class AppBarLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppBarLogo({super.key, this.size = 32, this.showText = false});

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: GlassmorphismTheme.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: CustomPaint(
        size: Size(size * 0.6, size * 0.6),
        painter: AppBarLogoPainter(),
      ),
    );

    if (!showText) {
      return logoWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoWidget,
        const SizedBox(width: 8),
        const Text(
          'BizTracker',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GlassmorphismTheme.textColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class AppBarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    // Simplified building shape for small size
    final buildingPath = Path();

    // Building base
    buildingPath.moveTo(center.dx - radius * 0.7, center.dy + radius * 0.3);
    buildingPath.lineTo(center.dx + radius * 0.7, center.dy + radius * 0.3);
    buildingPath.lineTo(center.dx + radius * 0.5, center.dy - radius * 0.2);
    buildingPath.lineTo(center.dx - radius * 0.5, center.dy - radius * 0.2);
    buildingPath.close();

    // Draw building
    canvas.drawPath(buildingPath, paint);

    // Draw simple chart line
    final chartPaint = Paint()
      ..color = GlassmorphismTheme.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;

    canvas.drawLine(
      Offset(center.dx - radius * 0.4, center.dy - radius * 0.4),
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.6),
      chartPaint,
    );

    // Draw one dot
    final dotPaint = Paint()
      ..color = GlassmorphismTheme.accentColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.6),
      size.width * 0.02,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
