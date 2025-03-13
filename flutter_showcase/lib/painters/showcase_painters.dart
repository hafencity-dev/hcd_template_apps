import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pattern painter for e-commerce app cards
class ECommercePatternPainter extends CustomPainter {
  final Color color;

  ECommercePatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw diagonal lines pattern
    const spacing = 20.0;
    for (double i = -size.width; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Progress ring painter for fitness app
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double? strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.color,
    this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final actualStrokeWidth = strokeWidth ?? size.width * 0.08;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = actualStrokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = actualStrokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -90 * (math.pi / 180); // Start from the top
    final sweepAngle = 360 * progress * (math.pi / 180);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Chart painter for banking app
class BankingChartPainter extends CustomPainter {
  final Color color;

  BankingChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // N26-style chart is more minimalistic with less pronounced gradients
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Subtle gradient fill, more like N26
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.15),
          color.withOpacity(0.03),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (int i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final path = Path();
    final fillPath = Path();

    // Generate smoother chart data - more N26-like
    final points = <Offset>[];
    final pointCount = 7; // One point for each month
    final segmentWidth = size.width / (pointCount - 1);

    // N26 charts typically show upward trend with some variation
    // these values represent a growing balance over time
    final yValues = [0.72, 0.65, 0.68, 0.75, 0.78, 0.86, 0.92];

    for (int i = 0; i < pointCount; i++) {
      final x = i * segmentWidth;
      final y = size.height * (1.0 - yValues[i]);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        // Create a smooth curve using cubic Bezier
        if (i > 0 && i < pointCount - 1) {
          final prevPoint = points[i - 1];
          final cp1 = Offset(prevPoint.dx + segmentWidth * 0.5, prevPoint.dy);
          final cp2 = Offset(x - segmentWidth * 0.5, y);
          path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, x, y);
          fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, x, y);
        } else {
          path.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }
    }

    // Complete the fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw the fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw the line - N26 uses crisp lines
    canvas.drawPath(path, paint);

    // Draw data points - N26 style with subtle indicators
    final highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Only highlight current point (last one)
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      if (i == points.length - 1) {
        // Main highlighted point (current value)
        canvas.drawCircle(point, 6.0, paint);
        canvas.drawCircle(point, 4.0, highlightPaint);
        canvas.drawCircle(point, 2.5, pointPaint);
      } else {
        // Small dot for other data points
        canvas.drawCircle(point, 2.0, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Activity chart painter
class ActivityChartPainter extends CustomPainter {
  final Color color;

  ActivityChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 7;
    final barWidth = size.width / (barCount * 2);
    final maxBarHeight = size.height * 0.8;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const values = [0.5, 0.7, 0.4, 0.8, 0.6, 0.9, 0.5];

    for (int i = 0; i < barCount; i++) {
      final barHeight = maxBarHeight * values[i];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * (barWidth * 2) + barWidth / 2,
          size.height - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }

    // Draw progress line
    final linePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height - maxBarHeight * values[0]);

    for (int i = 0; i < barCount; i++) {
      path.lineTo(
        i * (barWidth * 2) + barWidth,
        size.height - maxBarHeight * values[i],
      );
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pattern painter for food delivery app
class FoodDeliveryPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw circles pattern
    const circleCount = 12;
    const circleSize = 10.0;

    for (var i = 0; i < circleCount; i++) {
      final x = size.width * (i / circleCount);
      final y = size.height * 0.5 + (i % 2 == 0 ? -20.0 : 20.0);

      canvas.drawCircle(Offset(x, y), circleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Background painter for travel app
class TravelBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw stars/particles in the sky
    const starCount = 50;
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (var i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y =
          random.nextDouble() * size.height * 0.7; // Keep stars in top 70%
      final radius = 1.0 + random.nextDouble() * 2.0; // Random star size

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw some cloud shapes
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Cloud 1
    final cloud1Path = Path();
    cloud1Path.moveTo(size.width * 0.1, size.height * 0.3);
    cloud1Path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.15, size.height * 0.3), radius: 20));
    cloud1Path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.28), radius: 25));
    cloud1Path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.25, size.height * 0.31), radius: 18));
    cloud1Path.close();

    // Cloud 2
    final cloud2Path = Path();
    cloud2Path.moveTo(size.width * 0.6, size.height * 0.2);
    cloud2Path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.65, size.height * 0.2), radius: 15));
    cloud2Path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.7, size.height * 0.18), radius: 20));
    cloud2Path.addOval(Rect.fromCircle(
        center: Offset(size.width * 0.75, size.height * 0.21), radius: 15));
    cloud2Path.close();

    canvas.drawPath(cloud1Path, cloudPaint);
    canvas.drawPath(cloud2Path, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pattern painter for destination cards in travel app
class DestinationPatternPainter extends CustomPainter {
  final Color color;

  DestinationPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    // Draw a simple decorative pattern
    const dotSize = 4.0;
    const spacing = 20.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height / 2; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
