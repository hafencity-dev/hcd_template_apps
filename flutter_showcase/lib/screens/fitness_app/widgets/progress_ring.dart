import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../painters/showcase_painters.dart';

class ProgressRing extends StatelessWidget {
  final double value;
  final IconData icon;
  final String title;
  final String currentValue;
  final String goal;
  final Color color;
  final Duration delay;
  final double size;
  final double strokeWidth;
  final double fontSize;

  const ProgressRing({
    super.key,
    required this.value,
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.goal,
    required this.color,
    required this.delay,
    this.size = 100,
    this.strokeWidth = 8,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: ProgressRingPainter(
                  progress: value,
                  color: color,
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: size * 0.20),
                const SizedBox(height: 4),
                Text(
                  currentValue,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 400.ms, delay: delay).scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              duration: 400.ms,
              delay: delay,
              curve: Curves.easeOutQuad,
            ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Ziel: $goal',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
