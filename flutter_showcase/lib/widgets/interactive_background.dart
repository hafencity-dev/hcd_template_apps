import 'dart:math' as math;
import 'package:flutter/material.dart';

class InteractiveBackground extends StatefulWidget {
  final AnimationController controller;
  final Offset? externalMousePosition;
  final bool? externalMouseInside;

  const InteractiveBackground({
    super.key,
    required this.controller,
    this.externalMousePosition,
    this.externalMouseInside,
  });

  @override
  State<InteractiveBackground> createState() => _InteractiveBackgroundState();
}

class _InteractiveBackgroundState extends State<InteractiveBackground>
    with SingleTickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  bool _isMouseInside = false;
  List<MagicParticle> _particles = [];
  late AnimationController _particleController;

  // Define a magical color palette
  final Color primaryColor = const Color(0xFF6E8BF5); // Soft blue
  final Color accentColor = const Color(0xFFB292FF); // Soft purple
  final Color sparkleColor = const Color(0xFFFFF9C4); // Soft yellow

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Create initial particles
    _initParticles();
  }

  @override
  void didUpdateWidget(InteractiveBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update from external mouse position if provided
    if (widget.externalMousePosition != null) {
      _mousePosition = widget.externalMousePosition!;
    }
    if (widget.externalMouseInside != null) {
      _isMouseInside = widget.externalMouseInside!;
    }
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(50, (index) {
      return MagicParticle(
        position: Offset(
          random.nextDouble() * 1000,
          random.nextDouble() * 1000,
        ),
        size: 2.0 + random.nextDouble() * 3.0,
        speed: 0.2 + random.nextDouble() * 0.3,
        angle: random.nextDouble() * math.pi * 2,
        opacity: 0.1 + random.nextDouble() * 0.2,
        shimmerSpeed: 0.2 + random.nextDouble() * 0.3,
      );
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only use MouseRegion if no external mouse position is provided
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.controller, _particleController]),
        builder: (context, child) {
          // Update particle positions
          _updateParticles();

          return CustomPaint(
            painter: EnchantedBackgroundPainter(
              progress: widget.controller.value,
              mousePosition: _mousePosition,
              isMouseInside: _isMouseInside,
              primaryColor: primaryColor,
              accentColor: accentColor,
              sparkleColor: sparkleColor,
              particles: _particles,
              shimmerProgress: _particleController.value,
            ),
          );
        },
      ),
    );

    // If external mouse position is not provided, use MouseRegion to track locally
    if (widget.externalMousePosition == null) {
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
        child: content,
      );
    } else {
      // Otherwise just use the content directly
      return content;
    }
  }

  void _updateParticles() {
    final random = math.Random();

    for (var particle in _particles) {
      // Move particle
      particle.position += Offset(
        math.cos(particle.angle) * particle.speed,
        math.sin(particle.angle) * particle.speed,
      );

      // Slightly adjust angle for meandering effect
      particle.angle += (random.nextDouble() - 0.5) * 0.05;

      // Reset particles that go off-screen
      if (particle.position.dx < -50 ||
          particle.position.dx > 1050 ||
          particle.position.dy < -50 ||
          particle.position.dy > 1050) {
        particle.position = Offset(
          random.nextDouble() * 1000,
          random.nextDouble() * 1000,
        );
        particle.size = 2.0 + random.nextDouble() * 3.0;
        particle.speed = 0.2 + random.nextDouble() * 0.3;
        particle.angle = random.nextDouble() * math.pi * 2;
      }

      // Randomly adjust opacity for twinkling effect
      if (random.nextDouble() < 0.01) {
        particle.opacity = 0.1 + random.nextDouble() * 0.2;
      }
    }
  }
}

class MagicParticle {
  Offset position;
  double size;
  double speed;
  double angle;
  double opacity;
  double shimmerSpeed;

  MagicParticle({
    required this.position,
    required this.size,
    required this.speed,
    required this.angle,
    required this.opacity,
    required this.shimmerSpeed,
  });
}

class EnchantedBackgroundPainter extends CustomPainter {
  final double progress;
  final Offset mousePosition;
  final bool isMouseInside;
  final Color primaryColor;
  final Color accentColor;
  final Color sparkleColor;
  final List<MagicParticle> particles;
  final double shimmerProgress;

  EnchantedBackgroundPainter({
    required this.progress,
    required this.mousePosition,
    required this.isMouseInside,
    required this.primaryColor,
    required this.accentColor,
    required this.sparkleColor,
    required this.particles,
    required this.shimmerProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw gradient background
    _drawMagicalGradient(canvas, size);

    // Draw ethereal flow lines
    _drawEtherealFlowLines(canvas, size);

    // Draw magical particles
    _drawMagicalParticles(canvas, size);

    // Draw aurora effect
    _drawAuroraEffect(canvas, size);

    // Draw interactive magic circle if mouse is inside
    if (isMouseInside) {
      _drawInteractiveMagicCircle(canvas, size);
    }
  }

  void _drawMagicalGradient(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Create a subtle gradient that shifts with animation
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withOpacity(0.05),
        accentColor.withOpacity(0.07),
        primaryColor.withOpacity(0.06),
      ],
      stops: [
        0.0,
        0.5 + math.sin(progress * math.pi) * 0.1,
        1.0,
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawEtherealFlowLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final lineCount = 5;
    final wavesCount = 3;

    for (int i = 0; i < lineCount; i++) {
      final path = Path();
      final verticalPosition = size.height * (i / (lineCount - 1));

      paint.color = primaryColor
          .withOpacity(0.04 + 0.02 * math.sin(progress * math.pi + i));

      path.moveTo(0, verticalPosition);

      for (double x = 0; x <= size.width; x += 1) {
        double y = verticalPosition;

        // Add multiple wave patterns with different frequencies
        for (int w = 1; w <= wavesCount; w++) {
          final frequency = w * 0.005;
          final amplitude =
              size.height * 0.02 * (wavesCount - w + 1) / wavesCount;
          y += math.sin(x * frequency + progress * math.pi * 2 + i + w) *
              amplitude;
        }

        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  void _drawMagicalParticles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw all particles
    for (final particle in particles) {
      // Calculate shimmer effect with sine wave for magical twinkling
      final shimmerValue =
          (math.sin(shimmerProgress * math.pi * 2 * particle.shimmerSpeed) +
                  1) /
              2;

      final glow = Paint()
        ..color =
            sparkleColor.withOpacity(particle.opacity * 0.3 * shimmerValue)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      paint.color = sparkleColor.withOpacity(particle.opacity * shimmerValue);

      // Draw glow first (larger circle with blur)
      canvas.drawCircle(particle.position, particle.size * 2, glow);

      // Draw core particle
      canvas.drawCircle(particle.position, particle.size * 0.7, paint);
    }
  }

  void _drawAuroraEffect(Canvas canvas, Size size) {
    // Create a subtle aurora effect at the top of the screen
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.5);

    final auroraColors = [
      primaryColor.withOpacity(0.0),
      accentColor
          .withOpacity(0.03 * (0.7 + math.sin(progress * math.pi) * 0.3)),
      primaryColor.withOpacity(0.0),
    ];

    // Create shifting positions for aurora waves
    final stops = [
      0.0,
      0.5 + 0.2 * math.sin(progress * math.pi * 2),
      1.0,
    ];

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: auroraColors,
      stops: stops,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    // Draw the aurora with a wavy path
    final path = Path();
    path.moveTo(0, 0);

    final waveHeight = size.height * 0.1;
    final segmentWidth = size.width / 10;

    for (int i = 0; i <= 10; i++) {
      final x = i * segmentWidth;
      final waveOffset =
          waveHeight * math.sin(i * 0.5 + progress * math.pi * 2);
      path.lineTo(x, waveOffset);
    }

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawInteractiveMagicCircle(Canvas canvas, Size size) {
    final innerCirclePaint = Paint()
      ..color = sparkleColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final outerCirclePaint = Paint()
      ..color = accentColor.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // Draw ambient glow
    canvas.drawCircle(mousePosition,
        60 * (0.7 + 0.3 * math.sin(progress * math.pi * 4)), glowPaint);

    // Draw outer circle with inscribed magical symbols
    canvas.drawCircle(mousePosition, 40, outerCirclePaint);

    // Draw pulsing inner circle
    final innerRadius = 20 * (0.8 + 0.2 * math.sin(progress * math.pi * 8));
    canvas.drawCircle(mousePosition, innerRadius, innerCirclePaint);

    // Draw magical runes/symbols around the circle
    _drawMagicalRunes(canvas, mousePosition, 40);
  }

  void _drawMagicalRunes(Canvas canvas, Offset center, double radius) {
    final runeCount = 8;
    final runePaint = Paint()
      ..color = sparkleColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < runeCount; i++) {
      final angle = i * (math.pi * 2 / runeCount) + progress * math.pi;
      final position = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      // Draw a small magical symbol at this position
      final symbolPath = Path();

      // Simple rune shapes that vary based on the index
      if (i % 3 == 0) {
        // Star-like shape
        for (int j = 0; j < 5; j++) {
          final starAngle = j * (math.pi * 2 / 5) + progress * math.pi;
          final starRadius = 4.0;
          final point = Offset(
            position.dx + math.cos(starAngle) * starRadius,
            position.dy + math.sin(starAngle) * starRadius,
          );
          if (j == 0) {
            symbolPath.moveTo(point.dx, point.dy);
          } else {
            symbolPath.lineTo(point.dx, point.dy);
          }
        }
        symbolPath.close();
      } else if (i % 3 == 1) {
        // Circle with cross
        symbolPath.addOval(Rect.fromCircle(center: position, radius: 4));
        symbolPath.moveTo(position.dx - 5, position.dy);
        symbolPath.lineTo(position.dx + 5, position.dy);
        symbolPath.moveTo(position.dx, position.dy - 5);
        symbolPath.lineTo(position.dx, position.dy + 5);
      } else {
        // Triangle
        symbolPath.moveTo(position.dx, position.dy - 4);
        symbolPath.lineTo(position.dx + 4, position.dy + 3);
        symbolPath.lineTo(position.dx - 4, position.dy + 3);
        symbolPath.close();
      }

      canvas.drawPath(symbolPath, runePaint);
    }
  }

  @override
  bool shouldRepaint(EnchantedBackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.mousePosition != mousePosition ||
      oldDelegate.isMouseInside != isMouseInside ||
      oldDelegate.shimmerProgress != shimmerProgress;
}
