import 'package:flutter/material.dart';
import '../utils/glassmorphism_theme.dart';

class BizTrackerLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool animated;
  final Animation<double>? animation;

  const BizTrackerLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.animated = false,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: GlassmorphismTheme.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: GlassmorphismTheme.primaryColor.withOpacity(0.4),
            blurRadius: size * 0.25,
            spreadRadius: size * 0.04,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.25),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
          ),
          // Main logo design
          CustomPaint(
            size: Size(size * 0.6, size * 0.6),
            painter: BizTrackerLogoPainter(),
          ),
        ],
      ),
    );

    if (!showText) {
      return animated && animation != null
          ? AnimatedBuilder(
              animation: animation!,
              builder: (context, child) {
                return Transform.scale(
                  scale: animation!.value,
                  child: logoWidget,
                );
              },
            )
          : logoWidget;
    }

    final textWidget = Column(
      children: [
        animated && animation != null
            ? AnimatedBuilder(
                animation: animation!,
                builder: (context, child) {
                  return Transform.scale(
                    scale: animation!.value,
                    child: logoWidget,
                  );
                },
              )
            : logoWidget,
        SizedBox(height: size * 0.2),
        const Text(
          'BizTracker',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: GlassmorphismTheme.textColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your Business, Simplified',
          style: TextStyle(
            fontSize: 16,
            color: GlassmorphismTheme.textSecondaryColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    return textWidget;
  }
}

class BizTrackerLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    // Draw the main business building shape
    final buildingPath = Path();

    // Building base
    buildingPath.moveTo(center.dx - radius * 0.8, center.dy + radius * 0.4);
    buildingPath.lineTo(center.dx + radius * 0.8, center.dy + radius * 0.4);
    buildingPath.lineTo(center.dx + radius * 0.6, center.dy - radius * 0.2);
    buildingPath.lineTo(center.dx + radius * 0.4, center.dy - radius * 0.4);
    buildingPath.lineTo(center.dx - radius * 0.4, center.dy - radius * 0.4);
    buildingPath.lineTo(center.dx - radius * 0.6, center.dy - radius * 0.2);
    buildingPath.close();

    // Draw building
    canvas.drawPath(buildingPath, paint);
    canvas.drawPath(buildingPath, strokePaint);

    // Draw windows
    final windowPaint = Paint()
      ..color = GlassmorphismTheme.backgroundColor
      ..style = PaintingStyle.fill;

    // Left window
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.3, center.dy),
        width: radius * 0.2,
        height: radius * 0.15,
      ),
      windowPaint,
    );

    // Right window
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.3, center.dy),
        width: radius * 0.2,
        height: radius * 0.15,
      ),
      windowPaint,
    );

    // Door
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.2),
        width: radius * 0.25,
        height: radius * 0.2,
      ),
      windowPaint,
    );

    // Draw chart lines (representing business tracking)
    final chartPaint = Paint()
      ..color = GlassmorphismTheme.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    // Chart line 1
    canvas.drawLine(
      Offset(center.dx - radius * 0.6, center.dy - radius * 0.6),
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.7),
      chartPaint,
    );

    // Chart line 2
    canvas.drawLine(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.7),
      Offset(center.dx, center.dy - radius * 0.5),
      chartPaint,
    );

    // Chart line 3
    canvas.drawLine(
      Offset(center.dx, center.dy - radius * 0.5),
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.8),
      chartPaint,
    );

    // Chart line 4
    canvas.drawLine(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.8),
      Offset(center.dx + radius * 0.6, center.dy - radius * 0.6),
      chartPaint,
    );

    // Draw small dots on chart
    final dotPaint = Paint()
      ..color = GlassmorphismTheme.accentColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.7),
      size.width * 0.015,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.5),
      size.width * 0.015,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.8),
      size.width * 0.015,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
