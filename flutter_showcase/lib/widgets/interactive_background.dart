import 'dart:math' as math;
import 'package:flutter/material.dart';

class InteractiveBackground extends StatefulWidget {
  final AnimationController controller;

  const InteractiveBackground({
    super.key,
    required this.controller,
  });

  @override
  State<InteractiveBackground> createState() => _InteractiveBackgroundState();
}

class _InteractiveBackgroundState extends State<InteractiveBackground> {
  Offset _mousePosition = Offset.zero;
  bool _isMouseInside = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isMouseInside = true;
          _mousePosition = event.localPosition;
        });
      },
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
        });
      },
      onExit: (event) {
        setState(() {
          _isMouseInside = false;
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BackgroundPainter(
                progress: widget.controller.value,
                mousePosition: _mousePosition,
                isMouseInside: _isMouseInside,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double progress;
  final Offset mousePosition;
  final bool isMouseInside;

  BackgroundPainter({
    required this.progress,
    required this.mousePosition,
    required this.isMouseInside,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw animated shapes
    _drawAnimatedShapes(canvas, size, paint);

    // Draw interactive ripples if mouse is inside
    if (isMouseInside) {
      _drawInteractiveRipples(canvas, size, paint);
    }

    // Draw flutter logo subtly in the background
    _drawFlutterLogo(canvas, size);
  }

  void _drawAnimatedShapes(Canvas canvas, Size size, Paint paint) {
    final shapesCount = 8;
    final baseRadius = size.width * 0.15;

    for (int i = 0; i < shapesCount; i++) {
      final angle = (i / shapesCount) * 2 * math.pi + progress * 2 * math.pi;
      final oscillation = math.sin(progress * 2 * math.pi + i) * 0.5 + 0.5;
      final radius = baseRadius * (0.7 + oscillation * 0.3);
      
      final x = size.width * 0.5 + math.cos(angle) * size.width * 0.3;
      final y = size.height * 0.5 + math.sin(angle) * size.height * 0.3;
      
      paint.color = Colors.blue.withOpacity(0.05 + oscillation * 0.05);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawInteractiveRipples(Canvas canvas, Size size, Paint paint) {
    final rippleCount = 3;
    final maxRadius = size.width * 0.15;
    
    for (int i = 0; i < rippleCount; i++) {
      final progress = (this.progress + i / rippleCount) % 1.0;
      final radius = maxRadius * progress;
      
      paint.color = Colors.blue.withOpacity(0.1 * (1 - progress));
      canvas.drawCircle(mousePosition, radius, paint);
    }
  }

  void _drawFlutterLogo(Canvas canvas, Size size) {
    const flutterBlue = Color(0xFF0553B1);
    final paint = Paint()
      ..color = flutterBlue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw stylized Flutter logo as a subtle background element
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.2;
    
    // Draw the shield shape
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => 
    oldDelegate.progress != progress || 
    oldDelegate.mousePosition != mousePosition ||
    oldDelegate.isMouseInside != isMouseInside;
}