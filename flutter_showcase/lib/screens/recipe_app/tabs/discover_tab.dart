import 'package:flutter/material.dart';

class DiscoverTab extends StatelessWidget {
  final Color cardBgColor;
  final Color mainColor;

  const DiscoverTab({
    super.key,
    required this.cardBgColor,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      Icons.explore,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Entdecken',
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.tune,
                  color: Colors.grey[600],
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rezepte oder Zutaten suchen',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: mainColor.withOpacity(0.3), width: 1),
                ),
              ),
            ),
          ),
        ),

        // Main content
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Categories
              _buildCategories(),
              
              const SizedBox(height: 24),
              
              // Trending recipes
              _buildTrendingRecipes(),
              
              const SizedBox(height: 24),
              
              // Cuisines
              _buildCuisines(),
              
              const SizedBox(height: 60), // Bottom padding for FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategorien',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCategoryCard('Frühstück', Icons.wb_sunny_outlined, Colors.amber),
              const SizedBox(width: 12),
              _buildCategoryCard('Hauptgerichte', Icons.restaurant_menu, Colors.red),
              const SizedBox(width: 12),
              _buildCategoryCard('Salate', Icons.eco_outlined, Colors.green),
              const SizedBox(width: 12),
              _buildCategoryCard('Desserts', Icons.cake_outlined, Colors.purple),
              const SizedBox(width: 12),
              _buildCategoryCard('Snacks', Icons.lunch_dining_outlined, Colors.orange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingRecipes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Beliebte Rezepte',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTrendingRecipeCard(
          'Cremige Tomatenpasta',
          '30 Min',
          '4.8',
          Icons.favorite,
          Colors.red,
        ),
        const SizedBox(height: 12),
        _buildTrendingRecipeCard(
          'Hausgemachte Pizza',
          '45 Min',
          '4.7',
          Icons.star,
          Colors.amber,
        ),
        const SizedBox(height: 12),
        _buildTrendingRecipeCard(
          'Schokoladenkuchen',
          '50 Min',
          '4.9',
          Icons.favorite,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildTrendingRecipeCard(
    String title,
    String cookTime,
    String rating,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.restaurant,
              color: mainColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 10,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 3),
                    Text(
                      cookTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.star,
                      size: 10,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildTag('Vegetarisch'),
                    const SizedBox(width: 6),
                    _buildTag('Einfach'),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: mainColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildCuisines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weltküche entdecken',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCuisineCard('Italienisch'),
              _buildCuisineCard('Asiatisch'),
              _buildCuisineCard('Mexikanisch'),
              _buildCuisineCard('Griechisch'),
              _buildCuisineCard('Indisch'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCuisineCard(String cuisine) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.public,
              color: mainColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cuisine,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}