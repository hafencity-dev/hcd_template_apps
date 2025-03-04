import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/showcase_item.dart';

class ECommerceAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const ECommerceAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<ECommerceAppScreen> createState() => _ECommerceAppScreenState();
}

class _ECommerceAppScreenState extends State<ECommerceAppScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  int _cartItemCount = 0;
  int _currentBannerIndex = 0;
  int _selectedCategoryIndex = 0;
  final PageController _bannerController = PageController();
  
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Clothing', 'icon': Icons.checkroom_rounded},
    {'name': 'Electronics', 'icon': Icons.devices_rounded},
    {'name': 'Accessories', 'icon': Icons.watch_rounded},
    {'name': 'Home', 'icon': Icons.chair_rounded},
  ];
  
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Summer Collection',
      'subtitle': 'Discover our new styles',
      'tag': 'NEW',
      'tagColor': Colors.blue,
      'buttonText': 'Shop Now',
      'icon': Icons.checkroom_outlined,
    },
    {
      'title': 'New Tech Arrivals',
      'subtitle': 'Latest gadgets just in',
      'tag': 'HOT',
      'tagColor': Colors.orange,
      'buttonText': 'View New Items',
      'icon': Icons.devices_rounded,
    },
    {
      'title': 'Special Offers',
      'subtitle': 'Up to 50% off selected items',
      'tag': 'SALE',
      'tagColor': Colors.red,
      'buttonText': 'Shop Sale',
      'icon': Icons.local_offer_outlined,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // Auto-scroll banner
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _scrollToNextBanner();
      }
    });
  }
  
  void _scrollToNextBanner() {
    if (!mounted) return;
    
    _bannerController.animateToPage(
      (_currentBannerIndex + 1) % _banners.length,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    // Continue auto-scrolling
    Future.delayed(const Duration(seconds: 4), _scrollToNextBanner);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverToBoxAdapter(
            child: _buildAppBar(),
          ),
          
          // Search bar
          SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),
          
          // Featured product carousel
          SliverToBoxAdapter(
            child: _buildFeatureCarousel(),
          ),
          
          // Categories
          SliverToBoxAdapter(
            child: _buildCategories(),
          ),
          
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategoryIndex == 0 ? 'Popular Products' : _categories[_selectedCategoryIndex]['name'] + ' Products',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Smaller font size
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min, // Keep row as small as possible
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: widget.showcaseItem.color,
                          fontWeight: FontWeight.w500,
                          fontSize: 12, // Smaller font size
                        ),
                      ),
                      const SizedBox(width: 2), // Smaller spacing
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10, // Smaller icon
                        color: widget.showcaseItem.color,
                      ),
                    ],
                  ).animate()
                    .fadeIn(delay: 500.ms)
                    .slideX(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
          
          // Products grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _cartItemCount++;
                      });
                    },
                    child: _buildProductItem(index),
                  );
                },
                childCount: 4,
              ),
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: widget.showcaseItem.color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.showcaseItem.color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 18),
          ).animate()
            .fadeIn(duration: 300.ms)
            .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, curve: Curves.elasticOut),
          
          const Spacer(),
          
          const Text(
            'SHOP',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.5,
            ),
          ).animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: -0.2, end: 0, duration: 400.ms, delay: 100.ms),
          
          const Spacer(),
          
          _buildCartButton().animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .scaleXY(begin: 0.8, end: 1.0, duration: 300.ms, delay: 200.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
  
  Widget _buildCartButton() {
    return Stack(
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
            padding: const EdgeInsets.all(8),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
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
      .shimmer(delay: 3000.ms, duration: 1200.ms);
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search products...',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.tune_rounded, color: Colors.grey.shade500, size: 20),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 400.ms, delay: 200.ms)
      .slideY(begin: -0.2, end: 0, duration: 400.ms, delay: 200.ms, curve: Curves.easeOutQuad);
  }
  
  Widget _buildFeatureCarousel() {
    return SizedBox(
      height: 240, // Further increased height to avoid overflow
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: PageView.builder(
          controller: _bannerController,
          itemCount: _banners.length,
          onPageChanged: (index) {
            setState(() {
              _currentBannerIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final banner = _banners[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect( // Added ClipRRect to fix background pattern clipping issue
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  clipBehavior: Clip.none, // Prevent clipping of stacked elements
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ECommercePatternPainter(Colors.white),
                      ),
                    ),
                    
                    // Highlight shape
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
                        children: [
                          // Left text content
                          Expanded(
                            flex: 3, // Give more space to text content
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // Prevent vertical expansion
                              children: [
                                // Tag badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    banner['tag'],
                                    style: TextStyle(
                                      color: (banner['tagColor'] as Color),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ).animate()
                                  .fadeIn(duration: 600.ms, delay: 200.ms)
                                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms),
                                
                                const SizedBox(height: 12), // Reduced spacing
                                
                                // Title
                                Text(
                                  banner['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, // Smaller font size
                                    color: Colors.white,
                                  ),
                                  maxLines: 1, // Prevent text wrap
                                  overflow: TextOverflow.ellipsis, // Handle overflow
                                ).animate(key: ValueKey('title-$index'))
                                  .fadeIn(duration: 600.ms, delay: 300.ms)
                                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 300.ms),
                                
                                const SizedBox(height: 4), // Reduced spacing
                                
                                // Subtitle
                                Text(
                                  banner['subtitle'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13, // Smaller font size
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1, // Prevent text wrap
                                  overflow: TextOverflow.ellipsis, // Handle overflow
                                ).animate(key: ValueKey('subtitle-$index'))
                                  .fadeIn(duration: 600.ms, delay: 400.ms)
                                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 400.ms),
                                
                                const SizedBox(height: 16), // Fixed spacing
                                
                                // Button
                                SizedBox(
                                  height: 36, // Fixed height
                                  width: 140, // Fixed width
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
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      shadowColor: Colors.black.withOpacity(0.3),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            banner['buttonText'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11, // Even smaller font size
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        const Icon(Icons.arrow_forward_rounded, size: 12), // Smaller icon
                                      ],
                                    ),
                                  ),
                                ).animate(key: ValueKey('button-$index'))
                                  .fadeIn(duration: 600.ms, delay: 500.ms)
                                  .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 500.ms)
                                  .then()
                                  .shimmer(delay: 2000.ms, duration: 1200.ms),
                              ],
                            ),
                          ),
                          
                          // Right product icon
                          SizedBox(
                            width: 80, // Fixed width to prevent overflow
                            height: 80, // Fixed height
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background glow
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  // Icon
                                  Icon(
                                    banner['icon'],
                                    size: 50, // Smaller icon size
                                    color: Colors.white,
                                  ).animate(
                                    onPlay: (controller) => controller.repeat(reverse: true),
                                  ).scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.08, 1.08),
                                    duration: 2000.ms,
                                  ).rotate(
                                    begin: -0.05,
                                    end: 0.05,
                                    duration: 3000.ms,
                                  ),
                                ],
                              ),
                            ),
                          ).animate(key: ValueKey('icon-$index'))
                            .fadeIn(duration: 800.ms, delay: 300.ms)
                            .scaleXY(begin: 0.8, end: 1.0, duration: 800.ms, delay: 300.ms),
                        ],
                      ),
                    ),
                    
                    // Page indicator dots
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Prevent row expansion
                        children: List.generate(_banners.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: i == _currentBannerIndex ? 16 : 6, // Smaller dots
                            height: 6, // Smaller dots
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: i == _currentBannerIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).animate()
      .fadeIn(duration: 800.ms, delay: 400.ms)
      .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutQuad);
  }
  
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 16), // Reduced padding
      child: SizedBox(
        height: 90, // Reduced height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedCategoryIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6), // Reduced padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 60, // Smaller container
                      height: 60, // Smaller container
                      decoration: BoxDecoration(
                        color: isSelected ? widget.showcaseItem.color : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16), // Smaller radius
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: widget.showcaseItem.color.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        _categories[index]['icon'],
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        size: 24, // Smaller icon
                      ),
                    ).animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms + (100.ms * index))
                      .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 400.ms + (100.ms * index)),
                    
                    const SizedBox(height: 6), // Reduced spacing
                    
                    Text(
                      _categories[index]['name'],
                      style: TextStyle(
                        color: isSelected ? widget.showcaseItem.color : Colors.grey.shade800,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 11, // Smaller font
                      ),
                    ).animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms + (100.ms * index))
                      .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms + (100.ms * index)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildProductItem(int index) {
    final productColors = [
      Colors.blue.shade700,
      Colors.green.shade600,
      Colors.orange.shade700,
      Colors.purple.shade700,
    ];
    
    final products = [
      {'name': 'Premium T-Shirt', 'icon': Icons.checkroom, 'price': '\$24.99', 'discount': '20%', 'rating': 4.7},
      {'name': 'Smart Watch', 'icon': Icons.watch, 'price': '\$89.99', 'discount': '', 'rating': 4.9},
      {'name': 'Travel Backpack', 'icon': Icons.backpack, 'price': '\$49.99', 'discount': '10%', 'rating': 4.6},
      {'name': 'Wireless Headphones', 'icon': Icons.headphones, 'price': '\$79.99', 'discount': '', 'rating': 4.8},
    ];
    
    final product = products[index % 4];
    final color = productColors[index % 4];
    final hasDiscount = product['discount'] != null && product['discount'].toString().isNotEmpty;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect( // Add ClipRRect to prevent overflow
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Decorative circles (contained within bounds)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30, // Smaller decorative elements
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.1),
                        ),
                      ),
                    ),
                    
                    Positioned(
                      bottom: 5,
                      left: 0,
                      child: Container(
                        width: 20, // Smaller decorative elements
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.1),
                        ),
                      ),
                    ),
                    
                    // Product discount badge
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '-${product['discount']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9, // Smaller text
                            ),
                          ),
                        ).animate()
                          .shimmer(delay: (500 * index).ms, duration: 1200.ms)
                          .then()
                          .shimmer(delay: 4000.ms, duration: 1200.ms),
                      ),
                    
                    // Wishlist button
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4), // Smaller padding
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 12, // Smaller icon
                          color: color,
                        ),
                      ),
                    ),
                    
                    // Product icon
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          product['icon'] as IconData,
                          size: 40, // Smaller icon
                          color: color,
                        ).animate(
                          onPlay: (controller) => controller.repeat(reverse: true),
                        ).scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.08, 1.08),
                          duration: 2000.ms,
                          delay: (200 * index).ms,
                        ).rotate(
                          begin: -0.05,
                          end: 0.05,
                          duration: 3000.ms,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Product info
            Padding(
              padding: const EdgeInsets.all(10), // Smaller padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Prevent vertical expansion
                children: [
                  Text(
                    product['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Smaller font
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Smaller gap
                  
                  // Rating stars (simplified)
                  Row(
                    mainAxisSize: MainAxisSize.min, // Prevent horizontal expansion
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 12, // Smaller stars
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${product['rating']}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 10, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '(${24 + index * 7})',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10, // Smaller font
                        ),
                      ),
                    ],
                  ).animate()
                    .fadeIn(duration: 400.ms, delay: 600.ms + (index * 100).ms)
                    .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 600.ms + (index * 100).ms),
                  
                  const SizedBox(height: 6), // Smaller gap
                  
                  // Price and add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price with possible discount formatting
                      Flexible(
                        child: hasDiscount
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['price'] as String,
                                  style: TextStyle(
                                    color: widget.showcaseItem.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13, // Smaller font
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '\$${(double.parse((product['price'] as String).substring(1)) * 1.25).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10, // Smaller font
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : Text(
                              product['price'] as String,
                              style: TextStyle(
                                color: widget.showcaseItem.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13, // Smaller font
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                      
                      // Add to cart button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.showcaseItem.color,
                              widget.showcaseItem.color.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12), // Smaller radius
                          boxShadow: [
                            BoxShadow(
                              color: widget.showcaseItem.color.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6), // Smaller padding
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16, // Smaller icon
                        ),
                      ).animate(delay: (800 + 200 * index).ms)
                        .shimmer(duration: 1200.ms)
                        .then(delay: 3000.ms)
                        .scaleXY(begin: 1.0, end: 1.15, duration: 200.ms) // Fixed scale animation
                        .then(delay: 200.ms)
                        .scaleXY(begin: 1.15, end: 1.0, duration: 200.ms), // Fixed scale animation
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: (300 * index).ms)
      .slideY(
        begin: 0.3, 
        end: 0, 
        duration: 600.ms, 
        delay: (300 * index).ms,
        curve: Curves.easeOutQuad,
      );
  }
}

// Enhanced pattern painter for e-commerce app
class _ECommercePatternPainter extends CustomPainter {
  final Color color;
  
  _ECommercePatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    // Draw diagonal lines pattern
    const spacing = 30.0;
    for (double i = -size.width; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint
      );
    }
    
    // Draw circles pattern
    final circlePaint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    const circleSpacing = 60.0;
    const circleRadius = 5.0;
    
    for (double x = 0; x <= size.width; x += circleSpacing) {
      for (double y = 0; y <= size.height; y += circleSpacing) {
        canvas.drawCircle(Offset(x, y), circleRadius, circlePaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}