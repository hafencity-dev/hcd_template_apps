import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/showcase_item.dart';
import 'fitness_app/tabs/dashboard_tab.dart';
import 'fitness_app/tabs/workouts_tab.dart';
import 'fitness_app/tabs/nutrition_tab.dart';
import 'fitness_app/tabs/profile_tab.dart';

class FitnessAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const FitnessAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<FitnessAppScreen> createState() => _FitnessAppScreenState();
}

class _FitnessAppScreenState extends State<FitnessAppScreen> {
  int _selectedIndex = 0;

  // Fitness goals data
  final double _calorieGoal = 500;
  final double _caloriesBurned = 285;
  final double _stepsGoal = 10000;
  final double _stepsTaken = 8562;
  final double _activeMinutesGoal = 60;
  final double _activeMinutes = 42;

  // Get a color that will work well with the brand color
  Color get _accentColor => HSLColor.fromColor(widget.showcaseItem.color)
      .withLightness(0.7)
      .withSaturation(0.9)
      .toColor();

  @override
  Widget build(BuildContext context) {
    final darkBgColor = const Color(0xFF181824);
    final cardBgColor = const Color(0xFF252535);

    final List<Widget> _screens = [
      // Dashboard Tab
      DashboardTab(
        darkBgColor: darkBgColor,
        cardBgColor: cardBgColor,
        primaryGradient: LinearGradient(
          colors: [
            widget.showcaseItem.color.withOpacity(0.9),
            widget.showcaseItem.color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        mainColor: widget.showcaseItem.color,
        accentColor: _accentColor,
        calorieGoal: _calorieGoal,
        caloriesBurned: _caloriesBurned,
        stepsGoal: _stepsGoal,
        stepsTaken: _stepsTaken,
        activeMinutesGoal: _activeMinutesGoal,
        activeMinutes: _activeMinutes,
      ),

      // Workouts Tab
      WorkoutsTab(
        cardBgColor: cardBgColor,
        mainColor: widget.showcaseItem.color,
      ),

      // Nutrition Tab
      NutritionTab(
        cardBgColor: cardBgColor,
        accentColor: _accentColor,
        mainColor: widget.showcaseItem.color,
      ),

      // Profile Tab
      ProfileTab(
        cardBgColor: cardBgColor,
        mainColor: widget.showcaseItem.color,
        accentColor: _accentColor,
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: darkBgColor,
        body: SafeArea(
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: _buildBottomNav(darkBgColor),
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildBottomNav(Color darkBgColor) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: darkBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.dashboard_outlined, 'Start'),
          _buildNavItem(1, Icons.fitness_center_outlined, 'Workouts'),
          const SizedBox(width: 60), // Space for FAB
          _buildNavItem(2, Icons.restaurant_outlined, 'Ernährung'),
          _buildNavItem(3, Icons.person_outline, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = index == _selectedIndex;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? widget.showcaseItem.color
                  : Colors.white.withOpacity(0.5),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? widget.showcaseItem.color
                    : Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      height: 54,
      width: 54,
      child: FloatingActionButton(
        onPressed: () {
          // Show a snackbar when FAB is pressed in the demo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Neues Workout oder Aktivität hinzufügen'),
              backgroundColor: widget.showcaseItem.color,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: widget.showcaseItem.color,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
