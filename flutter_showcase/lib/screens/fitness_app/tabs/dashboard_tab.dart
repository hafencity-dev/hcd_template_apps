import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/progress_ring.dart';
import '../widgets/exercise_item.dart';
import '../../../painters/showcase_painters.dart';

class DashboardTab extends StatelessWidget {
  final Color darkBgColor;
  final Color cardBgColor;
  final LinearGradient primaryGradient;
  final Color mainColor;
  final Color accentColor;

  // Fitness goals data
  final double calorieGoal;
  final double caloriesBurned;
  final double stepsGoal;
  final double stepsTaken;
  final double activeMinutesGoal;
  final double activeMinutes;

  const DashboardTab({
    super.key,
    required this.darkBgColor,
    required this.cardBgColor,
    required this.primaryGradient,
    required this.mainColor,
    required this.accentColor,
    required this.calorieGoal,
    required this.caloriesBurned,
    required this.stepsGoal,
    required this.stepsTaken,
    required this.activeMinutesGoal,
    required this.activeMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App header with title
        Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: darkBgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            children: [
              // User greeting and stats
              _buildUserHeader(),

              const SizedBox(height: 16),

              // Daily Goals Card
              _buildDailyGoalsCard(),

              const SizedBox(height: 16),

              // Activity Summary
              _buildActivitySummary(),

              const SizedBox(height: 16),

              // Workout Suggestion
              _buildWorkoutSuggestion(),

              const SizedBox(height: 16),

              // Stats Grid
              _buildStatsGrid(),

              const SizedBox(height: 60), // Bottom padding for FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  mainColor.withOpacity(0.7),
                  mainColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Good morning,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.wb_sunny,
                      color: Colors.amber.shade300,
                      size: 14,
                    ),
                  ],
                ),
                const Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Let\'s reach your fitness goals today!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt,
                      color: mainColor,
                      size: 10,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '85%',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Steps Progress Ring
              Expanded(
                child: ProgressRing(
                  value: stepsTaken / stepsGoal,
                  icon: Icons.directions_walk,
                  title: 'STEPS',
                  currentValue: '${stepsTaken.toInt()}',
                  goal: '${stepsGoal.toInt()}',
                  color: mainColor,
                  delay: Duration.zero,
                  size: 64,
                  strokeWidth: 6,
                  fontSize: 14,
                ),
              ),

              // Calories Progress Ring
              Expanded(
                child: ProgressRing(
                  value: caloriesBurned / calorieGoal,
                  icon: Icons.local_fire_department,
                  title: 'CALORIES',
                  currentValue: '${caloriesBurned.toInt()}',
                  goal: '${calorieGoal.toInt()}',
                  color: Colors.orange,
                  delay: 100.ms,
                  size: 64,
                  strokeWidth: 6,
                  fontSize: 14,
                ),
              ),

              // Active Minutes Ring
              Expanded(
                child: ProgressRing(
                  value: activeMinutes / activeMinutesGoal,
                  icon: Icons.timer,
                  title: 'MINUTES',
                  currentValue: '${activeMinutes.toInt()}',
                  goal: '${activeMinutesGoal.toInt()}',
                  color: Colors.purple,
                  delay: 200.ms,
                  size: 64,
                  strokeWidth: 6,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activity Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    'This Week',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.7),
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: CustomPaint(
              painter: ActivityChartPainter(mainColor),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Mon', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Tue', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Wed', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Thu', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Fri', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Sat', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Sun', style: TextStyle(color: Colors.white70, fontSize: 9)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActivityIndicator(
                label: 'Best Day',
                value: 'Friday',
                icon: Icons.emoji_events,
                color: Colors.amber,
              ),
              _buildActivityIndicator(
                label: 'Streak',
                value: '7 days',
                icon: Icons.local_fire_department,
                color: Colors.orange,
              ),
              _buildActivityIndicator(
                label: 'Completed',
                value: '12 workouts',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityIndicator({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutSuggestion() {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: primaryGradient,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended Workout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Based on your fitness goals',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '45 min',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upper Body Strength',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ExerciseItem(
                      name: 'Push Ups',
                      sets: '3 sets',
                      reps: '12 reps',
                      icon: Icons.fitness_center,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    ExerciseItem(
                      name: 'Dumbbell Press',
                      sets: '4 sets',
                      reps: '10 reps',
                      icon: Icons.fitness_center,
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ExerciseItem(
                      name: 'Pull Ups',
                      sets: '3 sets',
                      reps: '8 reps',
                      icon: Icons.fitness_center,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 12),
                    ExerciseItem(
                      name: 'Bicep Curls',
                      sets: '3 sets',
                      reps: '12 reps',
                      icon: Icons.fitness_center,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start Workout',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Performance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              title: 'Heart Rate',
              value: '72 bpm',
              icon: Icons.favorite,
              color: Colors.red,
              iconBackground: Colors.red.withOpacity(0.2),
              trendValue: '+2%',
              trendUp: true,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              title: 'Sleep',
              value: '7h 20m',
              icon: Icons.nightlight_round,
              color: Colors.indigo,
              iconBackground: Colors.indigo.withOpacity(0.2),
              trendValue: '+12%',
              trendUp: true,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              title: 'Weight',
              value: '78.5 kg',
              icon: Icons.monitor_weight,
              color: Colors.teal,
              iconBackground: Colors.teal.withOpacity(0.2),
              trendValue: '-0.5%',
              trendUp: false,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              title: 'BMI',
              value: '22.5',
              icon: Icons.speed,
              color: Colors.amber,
              iconBackground: Colors.amber.withOpacity(0.2),
              trendValue: '-0.2%',
              trendUp: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconBackground,
    required String trendValue,
    required bool trendUp,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 14,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                        color: trendUp ? Colors.green : Colors.red,
                        size: 8,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trendValue,
                        style: TextStyle(
                          color: trendUp ? Colors.green : Colors.red,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
