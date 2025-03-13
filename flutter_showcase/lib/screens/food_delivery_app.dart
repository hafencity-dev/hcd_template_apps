import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:lottie/lottie.dart';

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

class _FoodDeliveryAppScreenState extends State<FoodDeliveryAppScreen>
    with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _animationController;
  late final AnimationController _cartAnimationController;
  late final AnimationController _menuAnimationController;

  // Page and scroll controllers
  final PageController _restaurantController = PageController();
  final ScrollController _scrollController = ScrollController();

  // State variables
  int _cartItemCount = 0;
  int _selectedCategoryIndex = 0;
  bool _showOrderDetails = false;
  bool _isOrdering = false;
  double _deliveryProgress = 0.0;
  Map<String, dynamic>? _selectedRestaurant;

  // Delightful interaction states
  bool _isLikeButtonTapped = false;
  bool _isAddButtonPressed = false;
  double _parallaxOffset = 0.0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Alle', 'icon': Icons.restaurant_menu},
    {'name': 'Pizza', 'icon': Icons.local_pizza},
    {'name': 'Burger', 'icon': Icons.lunch_dining},
    {'name': 'Sushi', 'icon': Icons.set_meal},
    {'name': 'Salat', 'icon': Icons.eco},
    {'name': 'Mexikanisch', 'icon': Icons.restaurant},
    {'name': 'Meeresfrüchte', 'icon': Icons.set_meal},
    {'name': 'Thai', 'icon': Icons.ramen_dining},
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
    },
    {
      'name': 'Taco Fiesta',
      'rating': 4.5,
      'delivery': '15-25 min',
      'tags': ['Mexican', 'Tacos'],
      'priceLevel': 1,
      'image': Icons.restaurant,
      'featured': false
    },
    {
      'name': 'Thai Express',
      'rating': 4.6,
      'delivery': '25-40 min',
      'tags': ['Thai', 'Spicy'],
      'priceLevel': 2,
      'image': Icons.ramen_dining,
      'featured': true
    },
    {
      'name': 'Pasta Paradise',
      'rating': 4.4,
      'delivery': '20-35 min',
      'tags': ['Italian', 'Pasta'],
      'priceLevel': 2,
      'image': Icons.dinner_dining,
      'featured': false
    },
    {
      'name': 'Fresh Catch',
      'rating': 4.8,
      'delivery': '25-40 min',
      'tags': ['Seafood', 'Grill'],
      'priceLevel': 3,
      'image': Icons.set_meal,
      'featured': false
    },
    {
      'name': 'Veggie Delight',
      'rating': 4.7,
      'delivery': '15-30 min',
      'tags': ['Vegetarian', 'Healthy'],
      'priceLevel': 2,
      'image': Icons.spa,
      'featured': false
    }
  ];

  @override
  void initState() {
    super.initState();
    // Set up animation controllers
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _cartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Listen for scroll events to create parallax effects
    _scrollController.addListener(() {
      setState(() {
        _parallaxOffset = _scrollController.offset * 0.1;
      });
    });

    // Auto-scroll featured restaurants
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _scrollToNextRestaurant();
      }
    });

    // Start with a random delivery progress for demo purposes
    _deliveryProgress = 0.65;
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
    return _restaurants
        .where((restaurant) => restaurant['featured'] == true)
        .toList();
  }

  List<Map<String, dynamic>> _getFilteredRestaurants() {
    if (_selectedCategoryIndex == 0) {
      return _restaurants
          .where((restaurant) => !restaurant['featured'])
          .toList();
    }

    String category = _categories[_selectedCategoryIndex]['name'];
    return _restaurants
        .where((restaurant) =>
            !restaurant['featured'] && restaurant['tags'].contains(category))
        .toList();
  }

  @override
  void dispose() {
    // Dispose all controllers
    _animationController.dispose();
    _cartAnimationController.dispose();
    _menuAnimationController.dispose();
    _restaurantController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper method to create a glassmorphic container
  Widget _buildGlassmorphicContainer({
    required Widget child,
    required double width,
    required double height,
    required double borderRadius,
    required Color gradientColor,
    double blurAmount = 10,
    List<BoxShadow>? boxShadow,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: gradientColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: gradientColor.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          // Background with subtle design elements
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.showcaseItem.color.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Main scrollable content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Modern app bar with glassmorphism
                Container(
                  padding: EdgeInsets.fromLTRB(12, statusBarHeight + 6, 12, 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.showcaseItem.color,
                        widget.showcaseItem.color.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.showcaseItem.color.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top row with menu and cart
                      Row(
                        children: [
                          // Menu button with animation
                          GestureDetector(
                            onTap: () {
                              _menuAnimationController.status ==
                                      AnimationStatus.completed
                                  ? _menuAnimationController.reverse()
                                  : _menuAnimationController.forward();
                            },
                            child: AnimatedBuilder(
                              animation: _menuAnimationController,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    _menuAnimationController.status ==
                                            AnimationStatus.completed
                                        ? Icons.close
                                        : Icons.menu,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                );
                              },
                            ).animate().scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1, 1),
                                  duration: 400.ms,
                                  curve: Curves.elasticOut,
                                ),
                          ),

                          const Spacer(),

                          // Logo with animated shine effect
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const Text(
                                'FOODIE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .then()
                              .shimmer(delay: 1500.ms, duration: 1200.ms)
                              .then(delay: 3000.ms)
                              .shimmer(duration: 1200.ms),

                          const Spacer(),

                          // Cart button with animation
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _cartItemCount++;
                                    _cartAnimationController.forward().then(
                                        (_) =>
                                            _cartAnimationController.reverse());
                                  });
                                },
                                child: AnimatedBuilder(
                                  animation: _cartAnimationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1 +
                                          (_cartAnimationController.value *
                                              0.2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (_cartItemCount > 0)
                                Positioned(
                                  top: -3,
                                  right: -3,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFF5252),
                                          Color(0xFFD50000)
                                        ],
                                      ),
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
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                      .animate(key: ValueKey(_cartItemCount))
                                      .scale(
                                          duration: 300.ms,
                                          curve: Curves.elasticOut)
                                      .then()
                                      .shake(duration: 300.ms),
                                ),
                            ],
                          ),
                        ],
                      ),

                      // Welcome text
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hunger?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Bestelle leckeres Essen',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .moveX(begin: -10, end: 0),
                    ],
                  ),
                ),

                // Search and filter
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Search bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: Colors.grey.shade600, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Restaurants und Gerichte suchen...',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.tune,
                                color: Colors.grey.shade600, size: 16),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms).moveX(
                          begin: -10,
                          end: 0,
                          duration: 400.ms,
                          delay: 200.ms,
                          curve: Curves.easeOutQuad),

                      // Category filter
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 34,
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final bool isSelected =
                                _selectedCategoryIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? widget.showcaseItem.color
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: widget.showcaseItem.color
                                                .withOpacity(0.3),
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _categories[index]['icon'],
                                      size: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _categories[index]['name'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .animate(
                                      key: ValueKey(
                                          'category-$index-$isSelected'))
                                  .scale(
                                    duration: 200.ms,
                                    begin: isSelected
                                        ? const Offset(0.95, 0.95)
                                        : const Offset(1, 1),
                                    end: isSelected
                                        ? const Offset(1.05, 1.05)
                                        : const Offset(1, 1),
                                  )
                                  .then(duration: 200.ms)
                                  .scale(
                                    begin: isSelected
                                        ? const Offset(1.05, 1.05)
                                        : const Offset(1, 1),
                                    end: const Offset(1, 1),
                                  ),
                            );
                          },
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 300.ms).moveX(
                          begin: -10,
                          end: 0,
                          duration: 400.ms,
                          delay: 300.ms,
                          curve: Curves.easeOutQuad),
                    ],
                  ),
                ),

                // Featured restaurants carousel
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _restaurantController,
                    itemCount: _getFeaturedRestaurants().length,
                    itemBuilder: (context, index) {
                      final restaurant = _getFeaturedRestaurants()[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                              color: widget.showcaseItem.color.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Background pattern
                            Positioned.fill(
                              child: CustomPaint(
                                painter: FoodPatternPainter(
                                    Colors.white.withOpacity(0.1)),
                              ),
                            ),

                            // Content
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Text content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Featured badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'EMPFOHLEN',
                                            style: TextStyle(
                                              color: widget.showcaseItem.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ).animate().shimmer(
                                            delay: 1000.ms, duration: 1000.ms),

                                        const SizedBox(height: 8),

                                        // Restaurant name
                                        Text(
                                          restaurant['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        )
                                            .animate(
                                                key: ValueKey('name-$index'))
                                            .fadeIn(
                                                duration: 600.ms, delay: 200.ms)
                                            .moveX(
                                                begin: -10,
                                                end: 0,
                                                duration: 600.ms,
                                                delay: 200.ms),

                                        const SizedBox(height: 6),

                                        // Tags
                                        Row(
                                          children: (restaurant['tags'] as List)
                                              .map(
                                                (tag) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                            .animate(
                                                key: ValueKey('tags-$index'))
                                            .fadeIn(
                                                duration: 600.ms, delay: 300.ms)
                                            .moveX(
                                                begin: -10,
                                                end: 0,
                                                duration: 600.ms,
                                                delay: 300.ms),

                                        const SizedBox(height: 6),

                                        // Rating and delivery time
                                        Row(
                                          children: [
                                            // Rating
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${restaurant['rating']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(width: 12),

                                            // Delivery time
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  restaurant['delivery'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                            .animate(
                                                key: ValueKey('details-$index'))
                                            .fadeIn(
                                                duration: 600.ms, delay: 400.ms)
                                            .moveX(
                                                begin: -10,
                                                end: 0,
                                                duration: 600.ms,
                                                delay: 400.ms),

                                        const Spacer(),

                                        // Order button
                                        SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _cartItemCount++;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor:
                                                  widget.showcaseItem.color,
                                              elevation: 2,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Jetzt Bestellen',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(Icons.arrow_forward,
                                                    size: 12),
                                              ],
                                            ),
                                          ),
                                        )
                                            .animate(
                                                key: ValueKey('button-$index'))
                                            .fadeIn(
                                                duration: 600.ms, delay: 500.ms)
                                            .moveY(
                                                begin: 10,
                                                end: 0,
                                                duration: 600.ms,
                                                delay: 500.ms)
                                            .then()
                                            .shimmer(
                                                delay: 1000.ms,
                                                duration: 1200.ms),
                                      ],
                                    ),
                                  ),

                                  // Restaurant icon image
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(
                                            restaurant['image'] as IconData,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                        )
                                            .animate(
                                              onPlay: (controller) => controller
                                                  .repeat(reverse: true),
                                            )
                                            .scale(
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
                ).animate().fadeIn(duration: 800.ms, delay: 400.ms).moveY(
                    begin: 30,
                    end: 0,
                    duration: 800.ms,
                    delay: 400.ms,
                    curve: Curves.easeOutQuad),

                // Nearby restaurants section
                Column(
                  children: [
                    // Section header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategoryIndex == 0
                                ? 'In der Nähe'
                                : '${_categories[_selectedCategoryIndex]['name']} Orte',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Alle anzeigen',
                                style: TextStyle(
                                  color: widget.showcaseItem.color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 10,
                                color: widget.showcaseItem.color,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Restaurant list
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Restaurant icon/image
                                Container(
                                  width: 70,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: widget.showcaseItem.color
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      restaurant['image'] as IconData,
                                      size: 30,
                                      color: widget.showcaseItem.color,
                                    ),
                                  ),
                                ),

                                // Restaurant details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Name and price level
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                restaurant['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
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
                                                    color: i <
                                                            (restaurant[
                                                                    'priceLevel']
                                                                as int)
                                                        ? widget
                                                            .showcaseItem.color
                                                        : Colors.grey.shade300,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 4),

                                        // Tags
                                        Text(
                                          (restaurant['tags'] as List)
                                              .join(' • '),
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 10,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        // Rating and delivery time
                                        Row(
                                          children: [
                                            // Rating
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade500,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 1),
                                                  Text(
                                                    '${restaurant['rating']}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 6),

                                            // Delivery time
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey.shade600,
                                                  size: 10,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  restaurant['delivery'],
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const Spacer(),

                                            // Order button
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                color:
                                                    widget.showcaseItem.color,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: widget
                                                        .showcaseItem.color
                                                        .withOpacity(0.2),
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            )
                                                .animate(
                                                    delay: (500 * index).ms)
                                                .shimmer(duration: 1200.ms),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate()
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

                    // Bottom padding
                    const SizedBox(height: 80),
                  ],
                ),

                // End of scrollable column
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
