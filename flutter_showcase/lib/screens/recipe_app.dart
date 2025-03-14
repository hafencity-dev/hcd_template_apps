import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/showcase_item.dart';
import 'recipe_app/tabs/home_tab.dart';
import 'recipe_app/tabs/discover_tab.dart';
import 'recipe_app/tabs/favorites_tab.dart';
import 'recipe_app/tabs/profile_tab.dart';

class RecipeAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const RecipeAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<RecipeAppScreen> createState() => _RecipeAppScreenState();
}

class _RecipeAppScreenState extends State<RecipeAppScreen> {
  int _selectedIndex = 0;

  // Recipe data
  final int _recipesViewed = 15;
  final int _recipesSaved = 8;
  final int _dishesCooked = 5;

  // Get a color that will work well with the brand color
  Color get _accentColor => HSLColor.fromColor(widget.showcaseItem.color)
      .withLightness(0.7)
      .withSaturation(0.9)
      .toColor();

  @override
  Widget build(BuildContext context) {
    final lightBgColor = Colors.white;
    final cardBgColor = Colors.grey[100];

    final List<Widget> _screens = [
      // Home Tab
      HomeTab(
        lightBgColor: lightBgColor,
        cardBgColor: cardBgColor!,
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
        recipesViewed: _recipesViewed,
        recipesSaved: _recipesSaved,
        dishesCooked: _dishesCooked,
      ),

      // Discover Tab
      DiscoverTab(
        cardBgColor: cardBgColor,
        mainColor: widget.showcaseItem.color,
      ),

      // Favorites Tab
      FavoritesTab(
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
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: lightBgColor,
        body: SafeArea(
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: _buildBottomNav(lightBgColor),
      ),
    );
  }

  Widget _buildBottomNav(Color lightBgColor) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: lightBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_outlined, 'Home'),
          _buildNavItem(1, Icons.explore_outlined, 'Entdecken'),
          _buildNavItem(2, Icons.favorite_outline, 'Favoriten'),
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
              color: isSelected ? widget.showcaseItem.color : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? widget.showcaseItem.color : Colors.grey[400],
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
