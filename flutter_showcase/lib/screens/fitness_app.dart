import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/showcase_item.dart';
import '../painters/showcase_painters.dart';

class FitnessAppScreen extends StatelessWidget {
  final ShowcaseItem showcaseItem;

  const FitnessAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E1E2A),
      child: Column(
        children: [
          // App bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E2A),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white),
                const Spacer(),
                const Text(
                  'FITNESS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Text(
                    ' 3 ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate(delay: 1500.ms)
                  .shake(duration: 600.ms, rotation: 0.05),
              ],
            ),
          ).animate()
            .fadeIn(duration: 400.ms),
          
          // User stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // User avatar 
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: showcaseItem.color, width: 2),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline,
                      color: showcaseItem.color,
                      size: 30,
                    ),
                  ),
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .moveX(begin: -20, end: 0, duration: 400.ms, delay: 100.ms),
                
                const SizedBox(width: 16),
                
                // User stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, Alex!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '285 calories',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.directions_run,
                            color: Colors.blue,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.5 km',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .moveX(begin: -20, end: 0, duration: 400.ms, delay: 200.ms),
              ],
            ),
          ),
          
          // Progress ring
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2A2A38),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: ProgressRingPainter(
                        progress: 0.85,
                        color: showcaseItem.color,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '8,562',
                              style: TextStyle(
                                color: showcaseItem.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'STEPS',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '85% of goal',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 800.ms, delay: 400.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 800.ms,
                      delay: 400.ms,
                      curve: Curves.elasticOut,
                    ),
                  
                  // Small activity indicators around the ring
                  Positioned(
                    top: 20,
                    left: 90,
                    child: _buildActivityBubble(
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                      label: '285',
                      delay: 800.ms,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 70,
                    child: _buildActivityBubble(
                      icon: Icons.timer,
                      color: Colors.purple,
                      label: '42m',
                      delay: 1000.ms,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 70,
                    child: _buildActivityBubble(
                      icon: Icons.directions_run,
                      color: Colors.blue,
                      label: '4.5km',
                      delay: 1200.ms,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Activity chart
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A38),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Weekly Activity',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: showcaseItem.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: showcaseItem.color,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+12%',
                              style: TextStyle(
                                color: showcaseItem.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: CustomPaint(
                      painter: ActivityChartPainter(showcaseItem.color),
                    ),
                  ).animate()
                    .custom(
                      duration: 1500.ms,
                      delay: 1000.ms,
                      builder: (context, value, child) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.transparent, showcaseItem.color],
                              stops: [1 - value, 1 - value + 0.05],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.srcATop,
                          child: child,
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Mon', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text('Tue', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text('Wed', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text('Thu', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text('Fri', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text('Sat', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text('Sun', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 600.ms)
            .moveY(begin: 20, end: 0, duration: 600.ms, delay: 600.ms),
          
          // Workout plans
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Text(
                          'Today\'s Workout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: showcaseItem.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: showcaseItem.color,
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(duration: 400.ms, delay: 800.ms)
                    .moveY(begin: 10, end: 0, duration: 400.ms, delay: 800.ms),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildWorkoutItem(
                          'Running',
                          '30 min • 4.5 km',
                          Icons.directions_run,
                          Colors.blue,
                          delay: 900.ms,
                        ),
                        _buildWorkoutItem(
                          'Strength Training',
                          '45 min • Full Body',
                          Icons.fitness_center,
                          Colors.red,
                          delay: 1000.ms,
                        ),
                        _buildWorkoutItem(
                          'Yoga',
                          '25 min • Flexibility',
                          Icons.self_improvement,
                          Colors.purple,
                          delay: 1100.ms,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityBubble({
    required IconData icon,
    required Color color,
    required String label,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A38),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: delay)
      .scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
        duration: 600.ms,
        delay: delay,
        curve: Curves.elasticOut,
      );
  }

  Widget _buildWorkoutItem(
    String title, 
    String subtitle, 
    IconData icon, 
    Color color, 
    {Duration delay = Duration.zero}
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.9),
                  color,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(Icons.play_arrow, color: color, size: 20),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 1000.ms,
            ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: delay)
      .moveX(begin: 30, end: 0, duration: 500.ms, delay: delay, curve: Curves.easeOutQuad);
  }
}