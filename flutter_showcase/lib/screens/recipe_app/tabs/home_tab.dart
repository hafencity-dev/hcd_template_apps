import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/recipe_item.dart';
import '../widgets/recipe_stats.dart';
import '../../../../painters/showcase_painters.dart';

class HomeTab extends StatelessWidget {
  final Color lightBgColor;
  final Color cardBgColor;
  final LinearGradient primaryGradient;
  final Color mainColor;
  final Color accentColor;

  // Recipe data
  final int recipesViewed;
  final int recipesSaved;
  final int dishesCooked;

  const HomeTab({
    super.key,
    required this.lightBgColor,
    required this.cardBgColor,
    required this.primaryGradient,
    required this.mainColor,
    required this.accentColor,
    required this.recipesViewed,
    required this.recipesSaved,
    required this.dishesCooked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App header with title
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: lightBgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Kochbuch',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // User greeting
              _buildUserHeader(),

              const SizedBox(height: 20),

              // Featured Recipe Card (moved up)
              _buildFeaturedRecipe(),

              const SizedBox(height: 20),

              // Recently Viewed Recipes
              _buildRecentlyViewedSection(),

              const SizedBox(height: 20),

              // Recipe Collections
              _buildRecipeCollections(),

              const SizedBox(height: 60), // Bottom padding for FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guten Appetit!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Was kochst du heute?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // User Avatar
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCookingStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deine Kochstatistik',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: mainColor,
                      size: 10,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+25%',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RecipeStats(
                value: recipesViewed,
                title: 'ANGESEHEN',
                icon: Icons.visibility,
                color: Colors.blue,
              ),
              RecipeStats(
                value: recipesSaved,
                title: 'GESPEICHERT',
                icon: Icons.bookmark,
                color: Colors.amber,
              ),
              RecipeStats(
                value: dishesCooked,
                title: 'GEKOCHT',
                icon: Icons.restaurant,
                color: mainColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyViewedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Zuletzt angesehen',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Alle anzeigen',
                style: TextStyle(
                  fontSize: 12,
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              RecipeItem(
                title: 'Spaghetti Carbonara',
                cookTime: '25 Min',
                difficulty: 'Einfach',
                imageUrl: 'assets/placeholder.png',
                color: mainColor,
              ),
              const SizedBox(width: 12),
              RecipeItem(
                title: 'Avocado Toast',
                cookTime: '10 Min',
                difficulty: 'Sehr einfach',
                imageUrl: 'assets/placeholder.png',
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              RecipeItem(
                title: 'Gemüse-Curry',
                cookTime: '40 Min',
                difficulty: 'Mittel',
                imageUrl: 'assets/placeholder.png',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedRecipe() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: primaryGradient,
      ),
      clipBehavior: Clip.none,
      child: Stack(
        children: [
          // Food illustration element
          Positioned(
            bottom: -10,
            right: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
            ),
          ),

          // Secondary smaller circle
          Positioned(
            top: -30,
            left: 100,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'TAGESREZEPT',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Spacer(),
                const Text(
                  'Mediterraner Quinoa-Salat',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 16,
                  children: [
                    _buildRecipeInfo(Icons.access_time, '30 Min'),
                    _buildRecipeInfo(Icons.whatshot, '320 kcal'),
                    _buildRecipeInfo(Icons.star, '4.8'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: mainColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: const Size(100, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Anzeigen',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCollections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rezeptsammlungen',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCollectionCard(
                'Frühstück',
                '12 Rezepte',
                Icons.wb_sunny,
                Colors.amber,
              ),
              const SizedBox(width: 12),
              _buildCollectionCard(
                'Schnelle Küche',
                '8 Rezepte',
                Icons.timer,
                Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildCollectionCard(
                'Vegetarisch',
                '15 Rezepte',
                Icons.eco,
                Colors.green,
              ),
              const SizedBox(width: 12),
              _buildCollectionCard(
                'Desserts',
                '9 Rezepte',
                Icons.cake,
                Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionCard(
    String title,
    String recipeCount,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            recipeCount,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
