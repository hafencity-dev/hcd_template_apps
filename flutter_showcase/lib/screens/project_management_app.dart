import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/showcase_item.dart';
import 'project_management_app/tabs/dashboard_tab.dart';
import 'project_management_app/tabs/projects_tab.dart';
import 'project_management_app/tabs/tasks_tab.dart';
import 'project_management_app/tabs/profile_tab.dart';

class ProjectManagementAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const ProjectManagementAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<ProjectManagementAppScreen> createState() => _ProjectManagementAppScreenState();
}

class _ProjectManagementAppScreenState extends State<ProjectManagementAppScreen> {
  int _selectedIndex = 0;

  // Data
  final int _totalProjects = 8;
  final int _completedProjects = 3;
  final int _pendingTasks = 12;

  // Get a color that will work well with the brand color
  Color get _accentColor => HSLColor.fromColor(widget.showcaseItem.color)
      .withLightness(0.7)
      .withSaturation(0.9)
      .toColor();

  @override
  Widget build(BuildContext context) {
    final darkBgColor = const Color(0xFF1A1A2E);
    final cardBgColor = const Color(0xFF252542);
    final textColor = Colors.white;
    final secondaryTextColor = Colors.white70;

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
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
        totalProjects: _totalProjects,
        completedProjects: _completedProjects,
        pendingTasks: _pendingTasks,
      ),

      // Projects Tab
      ProjectsTab(
        darkBgColor: darkBgColor,
        cardBgColor: cardBgColor,
        mainColor: widget.showcaseItem.color,
        accentColor: _accentColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
      ),

      // Tasks Tab
      TasksTab(
        darkBgColor: darkBgColor,
        cardBgColor: cardBgColor,
        mainColor: widget.showcaseItem.color,
        accentColor: _accentColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
      ),

      // Profile Tab
      ProfileTab(
        darkBgColor: darkBgColor,
        cardBgColor: cardBgColor,
        mainColor: widget.showcaseItem.color,
        accentColor: _accentColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
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
      ),
    );
  }

  Widget _buildBottomNav(Color darkBgColor) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: darkBgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.dashboard_outlined, 'Dashboard'),
          _buildNavItem(1, Icons.folder_outlined, 'Projekte'),
          _buildNavItem(2, Icons.check_circle_outline, 'Aufgaben'),
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
              size: 22,
            ),
            const SizedBox(height: 4),
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

}