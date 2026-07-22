import 'package:flutter/material.dart';

class DottedGradientBorderContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final List<Color> gradientColors;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final double borderRadius;

  const DottedGradientBorderContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.gradientColors = const [
      Color(0xFF4A90E2),
      Color(0xFF9B51E0),
    ],
    this.strokeWidth = 1,
    this.dashLength = 5,
    this.dashSpace = 2,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedGradientBorderPainter(
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 110, vertical: 12),
        child: child,
      ),
    );
  }
}

class DottedGradientBorderPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final double borderRadius;

  DottedGradientBorderPainter({
    required this.gradientColors,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect);

    // Calculate the total length of the rounded rectangle path
    final path = Path()..addRRect(rRect);
    final metrics = path.computeMetrics().first;
    final pathLength = metrics.length;

    // Draw the dashed border
    double distance = 0;
    bool drawLine = true;

    while (distance < pathLength) {
      double length = drawLine ? dashLength : dashSpace;
      if (distance + length > pathLength) {
        length = pathLength - distance;
      }

      final extractPath = metrics.extractPath(distance, distance + length);
      if (drawLine) {
        canvas.drawPath(extractPath, paint);
      }

      distance += length;
      drawLine = !drawLine;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
