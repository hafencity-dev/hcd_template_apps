import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/showcase_item.dart';

class AppShowcaseItem extends StatelessWidget {
  final ShowcaseItem showcaseItem;
  final bool isSelected;

  const AppShowcaseItem({
    super.key,
    required this.showcaseItem,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuint,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        /*boxShadow: [
          BoxShadow(
            color: showcaseItem.color.withOpacity(isSelected ? 0.35 : 0.1),
            blurRadius: isSelected ? 16 : 10,
            spreadRadius: isSelected ? 2 : 0,
            offset: isSelected ? const Offset(0, 7) : const Offset(0, 5),
          ),
        ],*/
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            showcaseItem.color,
            showcaseItem.color,
          ],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: _buildBackgroundPattern(),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      showcaseItem.icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ).animate(target: isSelected ? 1 : 0).scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.05, 1.05)),

                  const SizedBox(width: 20),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          showcaseItem.title,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildFeatureRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Animated overlay for hover effect
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: 300.ms,
            child: Stack(
              children: [
                // Glow effect
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // Border effect
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
                    .animate(target: isSelected ? 1 : 0)
                    .shimmer(duration: 1200.ms, delay: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return CustomPaint(
      painter: PatternPainter(color: showcaseItem.color),
    );
  }

  Widget _buildFeatureRow() {
    return Container();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFeatureDot('UI/UX'),
          _buildFeatureDot('Animations'),
          _buildFeatureDot('Responsive'),
        ],
      ),
    );
  }

  Widget _buildFeatureDot(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final patternSize = 20.0;
    final rowCount = (size.height / patternSize).ceil() + 1;
    final columnCount = (size.width / patternSize).ceil() + 1;

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        // Create alternating pattern
        if ((i + j) % 2 == 0) {
          final rect = Rect.fromLTWH(
            j * patternSize,
            i * patternSize,
            patternSize,
            patternSize,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }

    // Add a stylized app screen in the background
    final screenWidth = size.width * 0.3;
    final screenHeight = screenWidth * 0.75;
    final screenX = size.width - screenWidth * 0.7;
    final screenY = size.height - screenHeight * 0.7;

    final screenPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(screenX, screenY, screenWidth, screenHeight),
      const Radius.circular(8),
    );

    canvas.drawRRect(screenRect, screenPaint);
  }

  @override
  bool shouldRepaint(PatternPainter oldDelegate) => false;
}
