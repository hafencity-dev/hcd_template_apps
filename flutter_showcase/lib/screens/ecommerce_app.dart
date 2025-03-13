import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

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

class _ECommerceAppScreenState extends State<ECommerceAppScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  int _cartItemCount = 0;
  int _currentBannerIndex = 0;
  int _selectedCategoryIndex = 0;
  final PageController _bannerController = PageController();
  final ScrollController _scrollController = ScrollController();

  // Add state for search functionality
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  String _searchQuery = '';

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

    // Listen to focus changes for search field
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
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
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Color overlay for the glassmorphism effect
  Color get _glassOverlayColor => widget.showcaseItem.color.withOpacity(0.03);

  // Get surface color variant based on theme color
  Color get _surfaceColor => HSLColor.fromColor(widget.showcaseItem.color)
      .withLightness(0.95)
      .withSaturation(0.05)
      .toColor();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final topPadding = mediaQuery.padding.top;

    return Material(
      color: _surfaceColor,
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: _buildBackgroundPattern(),
          ),

          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 60 + topPadding,
                  maxHeight: 60 + topPadding,
                  child: _buildAppBar(topPadding),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),

              // Featured product carousel
              SliverToBoxAdapter(
                child: _buildFeatureCarousel(screenSize),
              ),

              // Categories
              SliverToBoxAdapter(
                child: _buildCategories(),
              ),

              // Header
              SliverToBoxAdapter(
                child: _buildCategoryHeader(),
              ),

              // Products grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildProductItem(index);
                    },
                    childCount: 4,
                  ),
                ),
              ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: 20 + mediaQuery.padding.bottom),
              ),
            ],
          ),

          // Floating action button
          Positioned(
            bottom: 24 + mediaQuery.padding.bottom,
            right: 24,
            child: _buildFloatingActionButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    // Create a subtle background pattern
    return CustomPaint(
      painter: _BackgroundPatternPainter(
        baseColor: widget.showcaseItem.color,
      ),
    );
  }

  Widget _buildAppBar(double topPadding) {
    return _GlassmorphicContainer(
      width: double.infinity,
      height: 60 + topPadding,
      borderRadius: 0,
      blur: 10,
      linearGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          widget.showcaseItem.color.withOpacity(0.9),
          widget.showcaseItem.color.withOpacity(0.85),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          widget.showcaseItem.color.withOpacity(0.3),
          widget.showcaseItem.color.withOpacity(0.1),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Menu button with ripple effect
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).scaleXY(
                  begin: 0.8,
                  end: 1.0,
                  duration: 300.ms,
                  curve: Curves.elasticOut),

              const Spacer(),

              // Animated logo with glow effect
              Stack(
                alignment: Alignment.center,
                children: [
                  // Logo glow
                  Text(
                    'SHOP',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  // Logo text
                  const Text(
                    'SHOP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: -0.2, end: 0, duration: 400.ms, delay: 100.ms)
                  .then()
                  .shimmer(duration: 1800.ms, delay: 2500.ms)
                  .then(delay: 4000.ms)
                  .shimmer(duration: 1800.ms),

              const Spacer(),

              _buildCartButton()
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .scaleXY(
                      begin: 0.8,
                      end: 1.0,
                      duration: 300.ms,
                      delay: 200.ms,
                      curve: Curves.elasticOut),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _cartItemCount++;
              });
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
        if (_cartItemCount > 0)
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF5252), Color(0xFFD50000)],
                ),
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
            )
                .animate(key: ValueKey(_cartItemCount))
                .scale(duration: 300.ms, curve: Curves.elasticOut)
                .then()
                .shake(duration: 300.ms),
          ),
      ],
    )
        .animate()
        .shimmer(delay: 2000.ms, duration: 1200.ms)
        .then()
        .shimmer(delay: 3000.ms, duration: 1200.ms);
  }

  Widget _buildSearchBar() {
    // Fake search suggestions
    final searchSuggestions = [
      {'text': 'Trending: Summer collection', 'icon': Icons.trending_up},
      {'text': 'Smart watches under \$100', 'icon': Icons.watch_outlined},
      {'text': 'Best rated headphones', 'icon': Icons.headphones_outlined},
      {'text': 'Discounted items', 'icon': Icons.discount_outlined},
    ];

    return Stack(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: GestureDetector(
            onTap: () {
              // Manually handle the focus to prevent event issues
              FocusScope.of(context).requestFocus(_searchFocusNode);
            },
            child: _GlassmorphicContainer(
              width: double.infinity,
              height: 45,
              borderRadius: 12,
              blur: 4,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.4),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        color: Colors.grey.shade500, size: 20),
                    const SizedBox(width: 12),
                    // Replace Text with TextField
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 13,
                            letterSpacing: -0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter button
                    InkWell(
                      onTap: () {
                        // Simply unfocus to avoid focus issues with overlays
                        _searchFocusNode.unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: widget.showcaseItem.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.tune_rounded,
                            color: widget.showcaseItem.color, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(
              begin: -0.2,
              end: 0,
              duration: 400.ms,
              delay: 200.ms,
              curve: Curves.easeOutQuad),
        ),

        // Search suggestions/results (only visible when search is focused)
        if (_isSearchFocused)
          Padding(
            padding: const EdgeInsets.only(top: 75),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: AnimatedCrossFade(
                firstChild: _buildSearchSuggestions(searchSuggestions),
                secondChild: _buildSearchResults(),
                crossFadeState: _searchQuery.isEmpty
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
                layoutBuilder:
                    (topChild, topChildKey, bottomChild, bottomChildKey) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      PositionedDirectional(
                        key: bottomChildKey,
                        child: bottomChild,
                      ),
                      PositionedDirectional(
                        key: topChildKey,
                        child: topChild,
                      ),
                    ],
                  );
                },
              ),
            )
                .animate()
                .fadeIn(duration: 200.ms)
                .slideY(begin: -0.1, end: 0, duration: 200.ms),
          ),
      ],
    );
  }

  // Widget for search suggestions
  Widget _buildSearchSuggestions(List<Map<String, dynamic>> searchSuggestions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suggestion title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Suggestions',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: -0.3,
            ),
          ),
        ),

        // Suggestions list
        ...searchSuggestions.map((suggestion) => InkWell(
              onTap: () {
                setState(() {
                  _searchController.text = suggestion['text'] as String;
                  _searchQuery = suggestion['text'] as String;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      suggestion['icon'] as IconData,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion['text'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 13,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.north_west_rounded,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            )),

        // Bottom padding
        const SizedBox(height: 12),
      ],
    );
  }

  // Widget for search results
  Widget _buildSearchResults() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                'Results for ',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: -0.3,
                ),
              ),
              Flexible(
                child: Text(
                  '"$_searchQuery"',
                  style: TextStyle(
                    color: widget.showcaseItem.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Fake search results
        ...List.generate(
            3,
            (index) => InkWell(
                  onTap: () {
                    // Just unfocus, in a real app this would navigate to product
                    _searchFocusNode.unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: widget.showcaseItem.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              index == 0
                                  ? Icons.checkroom_outlined
                                  : index == 1
                                      ? Icons.headphones
                                      : Icons.watch_outlined,
                              size: 18,
                              color: widget.showcaseItem.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                index == 0
                                    ? 'Premium $_searchQuery T-Shirt'
                                    : index == 1
                                        ? 'Wireless $_searchQuery Headphones'
                                        : '$_searchQuery Smart Watch',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                index == 0
                                    ? '\$24.99'
                                    : index == 1
                                        ? '\$79.99'
                                        : '\$89.99',
                                style: TextStyle(
                                  color: widget.showcaseItem.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

        // View all results button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: widget.showcaseItem.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'View all results',
                style: TextStyle(
                  color: widget.showcaseItem.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCarousel([Size? screenSize]) {
    return SizedBox(
      height: 120, // Further reduced height for more compact design
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
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
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.showcaseItem.color
                        .withOpacity(0.5), // More subtle opacity
                    widget.showcaseItem.color.withOpacity(0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.showcaseItem.color.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Minimal subtle background pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.05,
                        child: CustomPaint(
                          painter: _ECommercePatternPainter(Colors.white),
                        ),
                      ),
                    ),

                    // Background icon - stacked in the background
                    Positioned(
                      right: 10,
                      bottom: 5,
                      child: Opacity(
                        opacity: 0.2,
                        child: Icon(
                          banner['icon'],
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Content with more compact design
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tag pill with even smaller text
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              banner['tag'],
                              style: TextStyle(
                                color: (banner['tagColor'] as Color),
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),

                          const SizedBox(height: 3),

                          // Title with smaller font
                          Text(
                            banner['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 1),

                          // Subtitle with smaller font
                          Text(
                            banner['subtitle'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Spacer(),

                          // Compact button with smaller text
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _cartItemCount++;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 26),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    banner['buttonText'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.arrow_forward_rounded,
                                      size: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Minimal page indicator dots
                    Positioned(
                      bottom: 8,
                      right: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_banners.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: i == _currentBannerIndex ? 12 : 4,
                            height: 4,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              color: i == _currentBannerIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
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
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 300.ms);
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 48, // Reduced height since we're removing the subtitle
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedCategoryIndex == index;
            return GestureDetector(
              onTap: () {
                if (_selectedCategoryIndex != index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.showcaseItem.color.withOpacity(0.9)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade100,
                      width: 1,
                    ),
                    // Reduced shadow for flatter appearance
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  widget.showcaseItem.color.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with animated color transition
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          _categories[index]['icon'],
                          key: ValueKey<String>(
                              "icon_$index${isSelected ? "_selected" : ""}"),
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Text with animated color transition
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 350),
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade800,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                          fontSize: 13,
                          letterSpacing: -0.3,
                        ),
                        child: Text(
                          _categories[index]['name'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(
                  duration: 500.ms,
                  delay: 300.ms + (100.ms * index),
                )
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 500.ms,
                  delay: 300.ms + (100.ms * index),
                );
          },
        ),
      ),
    );
  }

  // Header section with category title
  Widget _buildCategoryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                _selectedCategoryIndex == 0
                    ? 'Popular Products'
                    : '${_categories[_selectedCategoryIndex]['name']} Products',
                key: ValueKey<int>(_selectedCategoryIndex),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          _GlassmorphicContainer(
            width: 84,
            height: 28,
            borderRadius: 14,
            blur: 4,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.showcaseItem.color.withOpacity(0.15),
                widget.showcaseItem.color.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.showcaseItem.color.withOpacity(0.2),
                widget.showcaseItem.color.withOpacity(0.1),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: widget.showcaseItem.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: widget.showcaseItem.color,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.2, end: 0),
        ],
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
      {
        'name': 'Premium T-Shirt',
        'icon': Icons.checkroom,
        'price': '\$24.99',
        'discount': '20%',
        'rating': 4.7,
        'category': 1, // Clothing
      },
      {
        'name': 'Smart Watch',
        'icon': Icons.watch,
        'price': '\$89.99',
        'discount': '',
        'rating': 4.9,
        'category': 3, // Accessories
      },
      {
        'name': 'Travel Backpack',
        'icon': Icons.backpack,
        'price': '\$49.99',
        'discount': '10%',
        'rating': 4.6,
        'category': 1, // Clothing
      },
      {
        'name': 'Wireless Headphones',
        'icon': Icons.headphones,
        'price': '\$79.99',
        'discount': '',
        'rating': 4.8,
        'category': 2, // Electronics
      },
    ];

    final product = products[index % 4];
    final color = productColors[index % 4];
    final hasDiscount = product['discount'] != null &&
        product['discount'].toString().isNotEmpty;

    // Check if product matches selected category or if "All" is selected
    final bool matchesCategory = _selectedCategoryIndex == 0 ||
        (product['category'] as int) == _selectedCategoryIndex;

    // Highlight effect for products when category changes
    final bool shouldHighlight = matchesCategory && _selectedCategoryIndex > 0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 450),
      opacity: matchesCategory ? 1.0 : 0.4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(
            matchesCategory ? 0.0 : 5.0), // Simple animation effect
        margin: EdgeInsets.all(
            matchesCategory ? 0.0 : 5.0), // Simple animation effect
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.03),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: shouldHighlight
                ? widget.showcaseItem.color.withOpacity(0.3)
                : Colors.grey.shade50,
            width: shouldHighlight ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image section
            AspectRatio(
              aspectRatio: 1.375, // Fixed aspect ratio instead of fixed height
              child: Stack(
                children: [
                  // Background color with animated transition
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        color: shouldHighlight
                            ? widget.showcaseItem.color.withOpacity(0.1)
                            : color.withOpacity(0.06),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Product discount badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '-${product['discount']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),

                  // Wishlist button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 12,
                        color: shouldHighlight
                            ? widget.showcaseItem.color.withOpacity(0.8)
                            : color.withOpacity(0.8),
                      ),
                    ),
                  ),

                  // Product icon with animation
                  Center(
                    child: Icon(
                      product['icon'] as IconData,
                      size: 40,
                      color: shouldHighlight
                          ? widget.showcaseItem.color.withOpacity(0.85)
                          : color.withOpacity(0.85),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.03, 1.03),
                          duration: 2500.ms,
                          delay: (200 * index).ms,
                        ),
                  ),

                  // Category match indicator (only shown when a specific category is selected)
                  if (shouldHighlight)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: widget.showcaseItem.color.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.0, 1.0),
                          duration: 400.ms,
                          curve: Curves.elasticOut,
                        ),
                ],
              ),
            ),

            // Product info section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product name
                    Text(
                      product['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(flex: 1),

                    // Price row
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price with discount
                        Expanded(
                          child: hasDiscount
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      product['price'] as String,
                                      style: TextStyle(
                                        color: widget.showcaseItem.color,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$${(double.parse((product['price'] as String).substring(1)) * 1.25).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),

                        // Add to cart button with animated color when category matches
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          decoration: BoxDecoration(
                            color: shouldHighlight
                                ? widget.showcaseItem.color
                                : widget.showcaseItem.color.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Rating stars - only shown for matching categories
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: matchesCategory ? 1.0 : 0.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: matchesCategory ? 14 : 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 10,
                              color: Colors.amber.shade300,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product['rating']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: (200 * index).ms).slideY(
          begin: 0.2,
          end: 0,
          duration: 500.ms,
          delay: (200 * index).ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _cartItemCount++;
        });
      },
      backgroundColor: widget.showcaseItem.color,
      foregroundColor: Colors.white,
      child: const Icon(
        Icons.add_shopping_cart_rounded,
        size: 20,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 800.ms)
        .scaleXY(begin: 0.7, end: 1.0, duration: 600.ms, delay: 800.ms);
  }
}

// SliverAppBar delegate for persistent header
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// Glassmorphic container widget for modern UI elements
class _GlassmorphicContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final Gradient linearGradient;
  final Gradient borderGradient;
  final Widget child;

  const _GlassmorphicContainer({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.blur,
    required this.linearGradient,
    required this.borderGradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: linearGradient,
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: -5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// Background pattern painter for subtle texture
class _BackgroundPatternPainter extends CustomPainter {
  final Color baseColor;

  _BackgroundPatternPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = baseColor.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    const double spacing = 20.0;
    const double radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Add slight offset to every other row for more organic feel
        double xOffset = y % (spacing * 2) == 0 ? spacing / 2 : 0;
        canvas.drawCircle(Offset(x + xOffset, y), radius, dotPaint);
      }
    }

    // Draw subtle waves
    final wavePaint = Paint()
      ..color = baseColor.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (double y = spacing; y < size.height; y += spacing * 4) {
      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x < size.width; x += spacing) {
        // Create gentle wave pattern
        double waveHeight = spacing / 2 * (x % (spacing * 2) == 0 ? 1 : -1);
        path.quadraticBezierTo(
          x + spacing / 2,
          y + waveHeight,
          x + spacing,
          y,
        );
      }

      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
          Offset(i, 0), Offset(i + size.height, size.height), paint);
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
