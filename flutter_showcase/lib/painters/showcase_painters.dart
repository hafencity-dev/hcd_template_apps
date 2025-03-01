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
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Progress ring painter for fitness app
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  ProgressRingPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final strokeWidth = size.width * 0.08;
    
    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, radius, bgPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
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
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
      
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
      
    final path = Path();
    final fillPath = Path();
    
    // Generate some random-looking but smooth chart data
    final points = <Offset>[];
    final pointCount = 7;
    final segmentWidth = size.width / (pointCount - 1);
    
    // Predefined Y values for a nice looking chart
    final yValues = [0.7, 0.5, 0.8, 0.6, 0.9, 0.7, 0.8];
    
    for (int i = 0; i < pointCount; i++) {
      final x = i * segmentWidth;
      final y = size.height * (1.0 - yValues[i]);
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        // Create a smooth curve
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
    
    // Draw the line
    canvas.drawPath(path, paint);
    
    // Draw small circles on the data points
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    for (final point in points) {
      canvas.drawCircle(point, 3.0, circlePaint);
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
      final y = random.nextDouble() * size.height * 0.7; // Keep stars in top 70%
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
    cloud1Path.addOval(Rect.fromCircle(center: Offset(size.width * 0.15, size.height * 0.3), radius: 20));
    cloud1Path.addOval(Rect.fromCircle(center: Offset(size.width * 0.2, size.height * 0.28), radius: 25));
    cloud1Path.addOval(Rect.fromCircle(center: Offset(size.width * 0.25, size.height * 0.31), radius: 18));
    cloud1Path.close();
    
    // Cloud 2
    final cloud2Path = Path();
    cloud2Path.moveTo(size.width * 0.6, size.height * 0.2);
    cloud2Path.addOval(Rect.fromCircle(center: Offset(size.width * 0.65, size.height * 0.2), radius: 15));
    cloud2Path.addOval(Rect.fromCircle(center: Offset(size.width * 0.7, size.height * 0.18), radius: 20));
    cloud2Path.addOval(Rect.fromCircle(center: Offset(size.width * 0.75, size.height * 0.21), radius: 15));
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