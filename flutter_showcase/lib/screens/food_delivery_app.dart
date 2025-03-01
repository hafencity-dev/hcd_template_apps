import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../models/showcase_item.dart';
import '../painters/showcase_painters.dart';

class FoodDeliveryAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const FoodDeliveryAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<FoodDeliveryAppScreen> createState() => _FoodDeliveryAppScreenState();
}

class _FoodDeliveryAppScreenState extends State<FoodDeliveryAppScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  int _cartItemCount = 0;
  int _selectedCategoryIndex = 0;
  final PageController _restaurantController = PageController();
  
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.restaurant_menu},
    {'name': 'Pizza', 'icon': Icons.local_pizza},
    {'name': 'Burger', 'icon': Icons.lunch_dining},
    {'name': 'Sushi', 'icon': Icons.set_meal},
    {'name': 'Salad', 'icon': Icons.eco},
  ];
  
  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'Pizza Palace',
      'rating': 4.8,
      'delivery': '15-25 min',
      'tags': ['Italian', 'Pizza'],
      'priceLevel': 2,
      'image': Icons.local_pizza,
      'featured': true
    },
    {
      'name': 'Burger House',
      'rating': 4.6,
      'delivery': '20-30 min',
      'tags': ['American', 'Burgers'],
      'priceLevel': 2,
      'image': Icons.lunch_dining,
      'featured': false
    },
    {
      'name': 'Sushi World',
      'rating': 4.9,
      'delivery': '25-35 min',
      'tags': ['Japanese', 'Sushi'],
      'priceLevel': 3,
      'image': Icons.set_meal,
      'featured': true
    },
    {
      'name': 'Green Bowl',
      'rating': 4.7,
      'delivery': '10-20 min',
      'tags': ['Healthy', 'Salads'],
      'priceLevel': 2,
      'image': Icons.eco,
      'featured': false
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // Auto-scroll featured restaurants
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _scrollToNextRestaurant();
      }
    });
  }
  
  void _scrollToNextRestaurant() {
    if (!mounted) return;
    
    final int nextPage = (_restaurantController.page?.round() ?? 0) + 1;
    final int nextIndex = nextPage % _getFeaturedRestaurants().length;
    
    _restaurantController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    // Continue auto-scrolling
    Future.delayed(const Duration(seconds: 5), _scrollToNextRestaurant);
  }
  
  List<Map<String, dynamic>> _getFeaturedRestaurants() {
    return _restaurants.where((restaurant) => restaurant['featured'] == true).toList();
  }
  
  List<Map<String, dynamic>> _getFilteredRestaurants() {
    if (_selectedCategoryIndex == 0) {
      return _restaurants.where((restaurant) => !restaurant['featured']).toList();
    }
    
    String category = _categories[_selectedCategoryIndex]['name'];
    return _restaurants.where((restaurant) => 
      !restaurant['featured'] && restaurant['tags'].contains(category)).toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _restaurantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          // App bar
          Container(
            padding: const EdgeInsets.all(16),
            color: widget.showcaseItem.color,
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white),
                const Spacer(),
                const Text(
                  'FOODIE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cartItemCount++;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                      ),
                    ),
                    if (_cartItemCount > 0)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              '$_cartItemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ).animate(key: ValueKey(_cartItemCount))
                          .scale(duration: 300.ms, curve: Curves.elasticOut)
                          .then()
                          .shake(duration: 300.ms),
                      ),
                  ],
                ).animate()
                  .shimmer(delay: 2000.ms, duration: 1200.ms)
                  .then()
                  .shimmer(delay: 3000.ms, duration: 1200.ms),
              ],
            ),
          ),
          
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search restaurants and dishes...',
                          style: TextStyle(color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.tune, color: Colors.grey.shade600),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .moveX(begin: -10, end: 0, duration: 400.ms, delay: 200.ms, curve: Curves.easeOutQuad),
                
                // Category filter
                const SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final bool isSelected = _selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? widget.showcaseItem.color 
                              : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: widget.showcaseItem.color.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ] : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _categories[index]['icon'],
                                size: 16,
                                color: isSelected ? Colors.white : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _categories[index]['name'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey.shade800,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ).animate(key: ValueKey('category-$index-$isSelected'))
                          .scale(
                            duration: 200.ms, 
                            begin: isSelected ? const Offset(0.95, 0.95) : const Offset(1, 1),
                            end: isSelected ? const Offset(1.05, 1.05) : const Offset(1, 1),
                          )
                          .then(duration: 200.ms)
                          .scale(
                            begin: isSelected ? const Offset(1.05, 1.05) : const Offset(1, 1),
                            end: const Offset(1, 1),
                          ),
                      );
                    },
                  ),
                ).animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .moveX(begin: -10, end: 0, duration: 400.ms, delay: 300.ms, curve: Curves.easeOutQuad),
              ],
            ),
          ),
          
          // Featured restaurants carousel
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _restaurantController,
              itemCount: _getFeaturedRestaurants().length,
              itemBuilder: (context, index) {
                final restaurant = _getFeaturedRestaurants()[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.showcaseItem.color.withOpacity(0.8),
                        widget.showcaseItem.color.withOpacity(0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.showcaseItem.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: FoodPatternPainter(Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Text content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Featured badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'FEATURED',
                                      style: TextStyle(
                                        color: widget.showcaseItem.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ).animate()
                                    .shimmer(delay: 1000.ms, duration: 1000.ms),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Restaurant name
                                  Text(
                                    restaurant['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ).animate(key: ValueKey('name-$index'))
                                    .fadeIn(duration: 600.ms, delay: 200.ms)
                                    .moveX(begin: -10, end: 0, duration: 600.ms, delay: 200.ms),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Tags
                                  Row(
                                    children: (restaurant['tags'] as List).map((tag) => 
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ).toList(),
                                  ).animate(key: ValueKey('tags-$index'))
                                    .fadeIn(duration: 600.ms, delay: 300.ms)
                                    .moveX(begin: -10, end: 0, duration: 600.ms, delay: 300.ms),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Rating and delivery time
                                  Row(
                                    children: [
                                      // Rating
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${restaurant['rating']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(width: 16),
                                      
                                      // Delivery time
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            restaurant['delivery'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).animate(key: ValueKey('details-$index'))
                                    .fadeIn(duration: 600.ms, delay: 400.ms)
                                    .moveX(begin: -10, end: 0, duration: 600.ms, delay: 400.ms),
                                  
                                  const Spacer(),
                                  
                                  // Order button
                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _cartItemCount++;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: widget.showcaseItem.color,
                                        elevation: 4,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Order Now',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward, size: 16),
                                        ],
                                      ),
                                    ),
                                  ).animate(key: ValueKey('button-$index'))
                                    .fadeIn(duration: 600.ms, delay: 500.ms)
                                    .moveY(begin: 10, end: 0, duration: 600.ms, delay: 500.ms)
                                    .then()
                                    .shimmer(delay: 1000.ms, duration: 1200.ms),
                                ],
                              ),
                            ),
                            
                            // Restaurant icon image
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Icon(
                                      restaurant['image'] as IconData,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ).animate(
                                    onPlay: (controller) => controller.repeat(reverse: true),
                                  ).scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.05, 1.05),
                                    duration: 2000.ms,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ).animate()
            .fadeIn(duration: 800.ms, delay: 400.ms)
            .moveY(begin: 30, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutQuad),
          
          // Nearby restaurants section
          Expanded(
            child: Column(
              children: [
                // Section header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategoryIndex == 0 
                            ? 'Nearby Restaurants' 
                            : '${_categories[_selectedCategoryIndex]['name']} Places',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'See All',
                            style: TextStyle(
                              color: widget.showcaseItem.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: widget.showcaseItem.color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Restaurant list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _getFilteredRestaurants().length,
                    itemBuilder: (context, index) {
                      final restaurant = _getFilteredRestaurants()[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _cartItemCount++;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Restaurant icon/image
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: widget.showcaseItem.color.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    restaurant['image'] as IconData,
                                    size: 40,
                                    color: widget.showcaseItem.color,
                                  ),
                                ),
                              ),
                              
                              // Restaurant details
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Name and price level
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              restaurant['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Price level
                                          Row(
                                            children: List.generate(
                                              3, 
                                              (i) => Text(
                                                '\$',
                                                style: TextStyle(
                                                  color: i < (restaurant['priceLevel'] as int) 
                                                      ? widget.showcaseItem.color 
                                                      : Colors.grey.shade300,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 8),
                                      
                                      // Tags
                                      Text(
                                        (restaurant['tags'] as List).join(' • '),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 8),
                                      
                                      // Rating and delivery time
                                      Row(
                                        children: [
                                          // Rating
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade500,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${restaurant['rating']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 8),
                                          
                                          // Delivery time
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.grey.shade600,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                restaurant['delivery'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          const Spacer(),
                                          
                                          // Order button
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: widget.showcaseItem.color,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: widget.showcaseItem.color.withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ).animate(delay: (500 * index).ms)
                                            .shimmer(duration: 1200.ms),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate()
                          .fadeIn(duration: 600.ms, delay: (200 * index).ms)
                          .moveY(
                            begin: 20, 
                            end: 0, 
                            duration: 600.ms, 
                            delay: (200 * index).ms,
                            curve: Curves.easeOutQuad,
                          ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodPatternPainter extends CustomPainter {
  final Color color;
  
  FoodPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    // Draw food-themed pattern (plates, utensils, etc.)
    final circleRadius = size.width * 0.05;
    final spacing = size.width * 0.15;
    
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        final x = col * spacing;
        final y = row * spacing;
        
        // Alternate between circles (plates) and crosses (utensils)
        if ((row + col) % 2 == 0) {
          // Draw circle (plate)
          canvas.drawCircle(Offset(x, y), circleRadius, paint);
        } else {
          // Draw fork and knife
          final forkStart = Offset(x - circleRadius, y - circleRadius);
          final forkEnd = Offset(x + circleRadius, y + circleRadius);
          canvas.drawLine(forkStart, forkEnd, paint);
          
          final knifeStart = Offset(x + circleRadius, y - circleRadius);
          final knifeEnd = Offset(x - circleRadius, y + circleRadius);
          canvas.drawLine(knifeStart, knifeEnd, paint);
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}