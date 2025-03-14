import 'package:flutter/material.dart';

class FavoritesTab extends StatelessWidget {
  final Color cardBgColor;
  final Color mainColor;
  final Color accentColor;

  const FavoritesTab({
    super.key,
    required this.cardBgColor,
    required this.mainColor,
    required this.accentColor,
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
                      Icons.favorite,
                      color: mainColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Favoriten',
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
                  Icons.filter_list,
                  color: Colors.grey[600],
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Favorites tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildTabSelector(),
        ),

        const SizedBox(height: 16),

        // Main content
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final recipes = [
                ('Spaghetti Carbonara', '25 Min', 'Einfach', '4.6', true),
                ('Avocado Toast', '10 Min', 'Sehr einfach', '4.8', true),
                ('Gemüse-Curry', '40 Min', 'Mittel', '4.7', false),
                ('Quinoa-Salat', '20 Min', 'Einfach', '4.5', true),
                ('Apfelkuchen', '60 Min', 'Mittel', '4.9', false),
              ];
              
              return _buildSavedRecipeCard(
                recipes[index].$1,
                recipes[index].$2,
                recipes[index].$3,
                recipes[index].$4,
                recipes[index].$5,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'Gespeichert',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Gekocht',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedRecipeCard(
    String title,
    String cookTime,
    String difficulty,
    String rating,
    bool isVegetarian,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 2),
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
          // Recipe image placeholder
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant,
                color: mainColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Recipe details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
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
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (isVegetarian) _buildTag('Vegetarisch', Colors.green),
                    if (isVegetarian) const SizedBox(width: 6),
                    _buildTag(difficulty, mainColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}