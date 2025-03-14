import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom painter that draws a logo with a single green square rotated 45 degrees
class LogoPainter extends CustomPainter {
  final Color primaryColor;
  final double mainSquareRotation;

  LogoPainter({
    this.primaryColor = const Color(0xFFADFFA8),
    this.mainSquareRotation = math.pi / 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Calculate size for the main square
    final double mainSquareSize = width * 0.6;

    // Create paint object
    final Paint mainPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Draw main square (rotated 45 degrees)
    canvas.save();
    canvas.translate(width * 0.5, height * 0.5);
    canvas.rotate(mainSquareRotation);
    final Rect mainRect = Rect.fromCenter(
      center: Offset.zero,
      width: mainSquareSize,
      height: mainSquareSize,
    );
    final RRect mainRRect = RRect.fromRectAndRadius(
      mainRect,
      Radius.circular(mainSquareSize * 0.2),
    );
    canvas.drawRRect(mainRRect, mainPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is LogoPainter) {
      return oldDelegate.primaryColor != primaryColor ||
          oldDelegate.mainSquareRotation != mainSquareRotation;
    }
    return true;
  }
}

/// Widget that displays the logo using the custom painter
class LogoWidget extends StatelessWidget {
  final double size;
  final Color primaryColor;

  const LogoWidget({
    super.key,
    this.size = 100,
    this.primaryColor = const Color(0xFFADFFA8),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: LogoPainter(
          primaryColor: primaryColor,
        ),
      ),
    );
  }
}

/// Animated version of the logo widget
class AnimatedLogoWidget extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Duration duration;

  const AnimatedLogoWidget({
    super.key,
    this.size = 100,
    this.primaryColor = const Color(0xFFADFFA8),
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _mainSquareAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _mainSquareAnimation = Tween<double>(
      begin: math.pi / 4,
      end: math.pi / 4 + 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: LogoPainter(
              primaryColor: widget.primaryColor,
              mainSquareRotation: _mainSquareAnimation.value,
            ),
          ),
        );
      },
    );
  }
}
