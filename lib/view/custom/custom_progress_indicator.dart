import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../config/constants/app_colors.dart';
import 'my_text_widget.dart';

class CustomCircularProgress extends StatelessWidget {
  final double progress; // Value from 0.0 to 1.0
  final double size;
  final double strokeWidth;

  const CustomCircularProgress({
    super.key,
    required this.progress,
    this.size = 200,
    this.strokeWidth = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CircularProgressPainter(
          progress: progress,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc with gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + (2 * math.pi * progress),
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow[700]!,
        Colors.green,
      ],
      stops: const [0.0, 0.3, 0.6, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw progress arc
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class CustomLinearProgress extends StatelessWidget {
  final double progress; // Value from 0.0 to 1.0
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final String label; // New: Custom label text

  const CustomLinearProgress({
    super.key,
    required this.progress,
    required this.label,
    this.height = 10,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: label, // Using custom label
              size: 12,
              weight: FontWeight.w600,
              color: Color(0x72292A2D),
            ),
            MyText(
              text: "${(progress * 100).round()}%",
              size: 12,
              weight: FontWeight.w700,
              color: progressColor,
              lineHeight: 1.33,
            )
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              Container(
                height: height,
                color: Color(0xFFF0F0F0),
              ),
              FractionallySizedBox(
                widthFactor: progress, // progress value
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                      color: progressColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

