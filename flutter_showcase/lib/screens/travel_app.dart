import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/showcase_item.dart';

class TravelAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const TravelAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<TravelAppScreen> createState() => _TravelAppScreenState();
}

class _TravelAppScreenState extends State<TravelAppScreen> with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.85);
  late final AnimationController _animationController;
  
  // State variables
  bool _isDark = false;
  int _selectedExperience = -1;
  String _selectedFilter = "All";
  bool _isSearching = false;
  int _currentDestinationIndex = 0;

  // Color scheme
  late final Color _primaryColor = const Color(0xFF5B61F4);
  late final Color _accentColor = const Color(0xFFFF4767);
  late final Color _tertiaryColor = const Color(0xFF00D0B0);
  late final Color _backgroundColor = _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F8FC);
  late final Color _cardColor = _isDark ? const Color(0xFF1A1A1A) : Colors.white;
  late final Color _textColor = _isDark ? Colors.white : const Color(0xFF1A1A2E);
  late final Color _textSecondaryColor = _isDark ? const Color(0xFFAAAAAA) : const Color(0xFF64748B);
  late final Color _dividerColor = _isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB);

  // Data
  final List<Map<String, dynamic>> _destinations = [
    {
      'title': 'Bali',
      'subtitle': 'Indonesia',
      'price': '1,250',
      'rating': 4.8,
      'reviews': 324,
      'image': 'bali',
      'distance': '7,865 km',
      'description': 'Experience lush landscapes, vibrant culture and pristine beaches on this tropical paradise.',
      'favorited': true,
      'filters': ['Beach', 'Nature', 'Cultural'],
    },
    {
      'title': 'Kyoto',
      'subtitle': 'Japan',
      'price': '1,890',
      'rating': 4.9,
      'reviews': 412,
      'image': 'kyoto',
      'distance': '9,420 km',
      'description': 'Discover ancient temples, traditional gardens and authentic Japanese experiences.',
      'favorited': false,
      'filters': ['Cultural', 'Historical', 'City'],
    },
    {
      'title': 'Santorini',
      'subtitle': 'Greece',
      'price': '1,640',
      'rating': 4.7,
      'reviews': 289,
      'image': 'santorini',
      'distance': '3,570 km',
      'description': 'Iconic white buildings, dramatic cliffs and breathtaking sunsets await.',
      'favorited': true,
      'filters': ['Beach', 'Romantic', 'Island'],
    },
    {
      'title': 'Maldives',
      'subtitle': 'Maldives',
      'price': '2,100',
      'rating': 4.9,
      'reviews': 512,
      'image': 'maldives',
      'distance': '8,940 km',
      'description': 'Crystal clear waters, overwater bungalows and world-class snorkeling experiences.',
      'favorited': false,
      'filters': ['Beach', 'Luxury', 'Romantic'],
    },
  ];
  
  final List<Map<String, dynamic>> _experiences = [
    {
      'title': 'Mountain Trekking',
      'location': 'Swiss Alps',
      'duration': '3 days',
      'price': '450',
      'image': 'trekking',
      'color': const Color(0xFF5B61F4),
      'icon': Icons.landscape_rounded,
    },
    {
      'title': 'Desert Safari',
      'location': 'Dubai',
      'duration': '1 day',
      'price': '120',
      'image': 'safari',
      'color': const Color(0xFFFF4767),
      'icon': Icons.terrain_rounded,
    },
    {
      'title': 'Diving Adventure',
      'location': 'Great Barrier Reef',
      'duration': '2 days',
      'price': '380',
      'image': 'diving',
      'color': const Color(0xFF00D0B0),
      'icon': Icons.water_rounded,
    },
  ];
  
  final List<String> _filters = ['All', 'Popular', 'Beach', 'Mountain', 'City', 'Cultural', 'Adventure'];
  
  final List<String> _recentSearches = [
    'Bali, Indonesia',
    'Tokyo, Japan',
    'Beach Resorts',
  ];
  
  final List<String> _popularSearches = [
    'Paris, France',
    'New York, USA',
    'Mountain Retreats',
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Add page controller listener
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentDestinationIndex != page) {
        setState(() {
          _currentDestinationIndex = page;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: _isDark ? Brightness.dark : Brightness.light,
        fontFamily: GoogleFonts.outfit().fontFamily,
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (!_isSearching) _buildHeader(),
        Expanded(
          child: _isSearching ? _buildSearchResults() : _buildMainContent(),
        ),
        _buildNavBar(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        children: [
          // Top bar with logo, user profile, and theme toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primaryColor, _accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "T",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Travelo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDark = !_isDark;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _dividerColor),
                      ),
                      child: Icon(
                        _isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                        color: _isDark ? _accentColor : _primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _dividerColor),
                      color: _cardColor,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: _textSecondaryColor,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Search bar
          GestureDetector(
            onTap: () {
              setState(() {
                _isSearching = true;
                _searchController.clear(); // Clear previous search when opening
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _dividerColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: _textSecondaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Search destinations...",
                    style: TextStyle(
                      color: _textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: _primaryColor,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).moveY(
                begin: -10,
                end: 0,
                duration: 400.ms,
                delay: 100.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Scrollable category filters
        SliverToBoxAdapter(
          child: _buildFilters(),
        ),
        
        // Featured destinations with a "peek" carousel
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Featured Destinations",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: _primaryColor,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _destinations.length,
                  itemBuilder: (context, index) => _buildDestinationCard(index),
                ),
              ),
              
              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _destinations.length,
                    (index) => Container(
                      width: _currentDestinationIndex == index ? 12 : 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _currentDestinationIndex == index
                            ? _primaryColor
                            : _dividerColor,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Experiences section with expandable cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Experiences",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: _primaryColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Explore",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildExperienceCard(index),
            childCount: _experiences.length,
          ),
        ),
        
        // Special offer banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildPromoBanner(),
          ),
        ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Search input with back button
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSearching = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _dividerColor),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: _textColor,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _dividerColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search destinations...",
                      hintStyle: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 12,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: _textSecondaryColor,
                          size: 16,
                        ),
                        onPressed: () => _searchController.clear(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    onSubmitted: (value) {
                      // Would handle actual search in a real app
                      if (value.isNotEmpty) {
                        // Would add to recent searches
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Recent and popular searches
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            children: [
              if (_recentSearches.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Searches",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _recentSearches.clear();
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        "Clear",
                        style: TextStyle(
                          fontSize: 11,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._recentSearches.map((text) => 
                  _buildSearchItem(text, Icons.history)
                ).toList(),
                const SizedBox(height: 16),
              ],
              
              Text(
                "Popular Searches",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 8),
              ..._popularSearches.map((text) => 
                _buildSearchItem(text, Icons.trending_up)
              ).toList(),
              
              const SizedBox(height: 16),
              
              // Filter chips for quick access
              Text(
                "Quick Filters",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filters.map((filter) => 
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                        _isSearching = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _dividerColor),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 11,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        // Would perform search in a real app
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _dividerColor),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _textSecondaryColor,
              size: 14,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.north_west,
              color: _textSecondaryColor,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 32,
      margin: const EdgeInsets.only(top: 6),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final selected = filter == _selectedFilter;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: selected ? _primaryColor : _cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? _primaryColor : _dividerColor,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? Colors.white : _textSecondaryColor,
                ),
              ),
            ),
          ).animate().fadeIn(
                duration: 300.ms,
                delay: (50 * index).ms,
              ).moveX(
                begin: 20,
                end: 0,
                duration: 300.ms,
                delay: (50 * index).ms,
              );
        },
      ),
    );
  }

  Widget _buildDestinationCard(int index) {
    final destination = _destinations[index];
    
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 4, 12, 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _dividerColor),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with tags and favorite button
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              children: [
                // Background with destination theme color
                Container(
                  color: _getThemeColor(index).withOpacity(0.2),
                  child: Center(
                    child: Icon(
                      _getDestinationIcon(destination['title']),
                      size: 60,
                      color: _getThemeColor(index).withOpacity(0.3),
                    ),
                  ),
                ),
                
                // Gradient overlay for text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Distance badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.near_me,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination['distance'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Favorite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _destinations[index]['favorited'] = !destination['favorited'];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        destination['favorited'] ? Icons.favorite : Icons.favorite_border,
                        color: destination['favorited'] ? _accentColor : Colors.grey,
                        size: 12,
                      ),
                    ),
                  ),
                ),
                
                // Location name overlay
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.place,
                            color: Colors.white,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              destination['subtitle'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  destination['description'],
                  style: TextStyle(
                    fontSize: 11,
                    color: _textSecondaryColor,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                
                // Bottom section with filters, rating, and price
                Row(
                  children: [
                    // Category tags in a scrollable row
                    Expanded(
                      child: SizedBox(
                        height: 22,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: (destination['filters'] as List).length,
                          itemBuilder: (context, filterIndex) {
                            final filter = (destination['filters'] as List)[filterIndex];
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _isDark ? const Color(0xFF303030) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFB800),
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            destination['rating'].toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Price and book button
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style: TextStyle(
                            fontSize: 10,
                            color: _textSecondaryColor,
                          ),
                        ),
                        Text(
                          "\$${destination['price']}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: 400.ms,
          delay: (100 * index).ms,
        ).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: (100 * index).ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildExperienceCard(int index) {
    final experience = _experiences[index];
    final isSelected = _selectedExperience == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedExperience = isSelected ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Collapsed content
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Icon with color background
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: experience['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        experience['icon'],
                        color: experience['color'],
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  // Experience details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 10,
                              color: _textSecondaryColor,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                experience['location'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _textSecondaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time,
                              size: 10,
                              color: _textSecondaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              experience['duration'],
                              style: TextStyle(
                                fontSize: 10,
                                color: _textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Price and expand/collapse icon
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${experience['price']}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        isSelected ? Icons.expand_less : Icons.expand_more,
                        color: _textSecondaryColor,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Expanded content
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: _dividerColor),
                    const SizedBox(height: 6),
                    Text(
                      "About this experience",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Immerse yourself in this unique adventure and create unforgettable memories. Our experienced guides will ensure your safety while you enjoy this amazing experience.",
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // What's included
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "What's included:",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              _buildIncludedItem("Equipment"),
                              _buildIncludedItem("Guide"),
                              _buildIncludedItem("Photos"),
                            ],
                          ),
                        ),
                        // Book button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: experience['color'],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text(
                            "Book",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              crossFadeState: isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      key: bottomChildKey,
                      top: 0,
                      child: bottomChild,
                    ),
                    Positioned(
                      key: topChildKey,
                      child: topChild,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 400.ms,
          delay: (100 * index + 200).ms,
        ).moveY(
          begin: 20,
          end: 0,
          duration: 400.ms,
          delay: (100 * index + 200).ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildIncludedItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: _tertiaryColor,
            size: 10,
          ),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Summer Special",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Get 15% off on your first booking",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              "USE15SUM",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms).moveY(
          begin: 20,
          end: 0,
          duration: 600.ms,
          delay: 600.ms,
        );
  }

  Widget _buildNavBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border(
          top: BorderSide(
            color: _dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.explore, "Explore", true),
            _buildNavItem(Icons.favorite_border, "Saved", false),
            _buildNavItem(Icons.local_activity_outlined, "Bookings", false),
            _buildNavItem(Icons.person_outline, "Profile", false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {},
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? _primaryColor : _textSecondaryColor,
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? _primaryColor : _textSecondaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper functions
  Color _getThemeColor(int index) {
    final colors = [_primaryColor, _accentColor, _tertiaryColor, Color(0xFFFF9E00)];
    return colors[index % colors.length];
  }

  IconData _getDestinationIcon(String destination) {
    switch (destination.toLowerCase()) {
      case 'bali':
        return Icons.beach_access;
      case 'kyoto':
        return Icons.temple_buddhist;
      case 'santorini':
        return Icons.sailing;
      case 'maldives':
        return Icons.water;
      default:
        return Icons.travel_explore;
    }
  }
}