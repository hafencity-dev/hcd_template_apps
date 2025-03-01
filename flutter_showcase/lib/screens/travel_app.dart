import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../models/showcase_item.dart';
import '../painters/showcase_painters.dart';

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
  late final AnimationController _animationController;
  int _selectedTabIndex = 0;
  int _selectedDestinationIndex = -1;
  final PageController _destinationController = PageController();
  bool _showFavorites = false;
  
  final List<Map<String, dynamic>> _destinations = [
    {
      'name': 'Bali, Indonesia',
      'description': 'Tropical paradise with beautiful beaches and rich culture',
      'rating': 4.8,
      'price': '\$1,200',
      'isFavorite': true,
      'image': Icons.beach_access,
      'activities': ['Beach', 'Temples', 'Hiking'],
      'temperature': '32°C',
      'featureColor': Colors.blue.shade600,
    },
    {
      'name': 'Kyoto, Japan',
      'description': 'Historic city with stunning temples and traditional gardens',
      'rating': 4.9,
      'price': '\$1,600',
      'isFavorite': false,
      'image': Icons.account_balance,
      'activities': ['Temples', 'Gardens', 'Traditional Tea'],
      'temperature': '24°C',
      'featureColor': Colors.red.shade700,
    },
    {
      'name': 'Santorini, Greece',
      'description': 'Breathtaking island with white buildings and blue domes',
      'rating': 4.8,
      'price': '\$1,800',
      'isFavorite': true,
      'image': Icons.sailing,
      'activities': ['Sailing', 'Beaches', 'Sunset Viewing'],
      'temperature': '28°C',
      'featureColor': Colors.purple.shade600,
    },
    {
      'name': 'Machu Picchu, Peru',
      'description': 'Ancient Incan citadel set high in the Andes Mountains',
      'rating': 4.9,
      'price': '\$1,500',
      'isFavorite': false,
      'image': Icons.terrain,
      'activities': ['Hiking', 'Archaeological Sites', 'Photography'],
      'temperature': '18°C',
      'featureColor': Colors.green.shade700,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    // Auto-scroll destinations
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        _scrollToNextDestination();
      }
    });
  }
  
  void _scrollToNextDestination() {
    if (!mounted) return;
    
    final int nextPage = (_destinationController.page?.round() ?? 0) + 1;
    final int nextIndex = nextPage % _destinations.length;
    
    _destinationController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    // Continue auto-scrolling
    Future.delayed(const Duration(seconds: 6), _scrollToNextDestination);
  }
  
  List<Map<String, dynamic>> _getFilteredDestinations() {
    if (_showFavorites) {
      return _destinations.where((dest) => dest['isFavorite'] == true).toList();
    }
    return _destinations;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _destinationController.dispose();
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
                  'TRAVEL',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFavorites = !_showFavorites;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      _showFavorites ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ).animate()
                  .shimmer(delay: 2000.ms, duration: 1200.ms)
                  .then()
                  .shimmer(delay: 3000.ms, duration: 1200.ms),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
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
                      'Search destinations...',
                      style: TextStyle(color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey.shade600),
                ],
              ),
            ),
          ).animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .moveX(begin: -10, end: 0, duration: 400.ms, delay: 200.ms, curve: Curves.easeOutQuad),
          
          // Navigation tabs
          Container(
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                for (int i = 0; i < 4; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = i;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: i == _selectedTabIndex
                              ? widget.showcaseItem.color
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Icon(
                            i == 0 ? Icons.explore :
                            i == 1 ? Icons.flight :
                            i == 2 ? Icons.hotel :
                            Icons.map,
                            color: i == _selectedTabIndex
                                ? Colors.white
                                : Colors.grey.shade500,
                            size: 24,
                          ),
                        ),
                      ).animate(key: ValueKey('tab-$i-${i == _selectedTabIndex}'))
                        .scale(
                          duration: 200.ms, 
                          begin: i == _selectedTabIndex ? const Offset(0.9, 0.9) : const Offset(1, 1),
                          end: i == _selectedTabIndex ? const Offset(1.05, 1.05) : const Offset(1, 1),
                        )
                        .then(duration: 200.ms)
                        .scale(
                          begin: i == _selectedTabIndex ? const Offset(1.05, 1.05) : const Offset(1, 1),
                          end: const Offset(1, 1),
                        ),
                    ),
                  ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .moveY(begin: 10, end: 0, duration: 600.ms, delay: 300.ms, curve: Curves.easeOutQuad),
          
          // Destinations carousel
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _destinationController,
              itemCount: _destinations.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedDestinationIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final destination = _destinations[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDestinationIndex = _selectedDestinationIndex == index ? -1 : index;
                      
                      if (!destination['isFavorite']) {
                        _destinations[index]['isFavorite'] = true;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (destination['featureColor'] as Color).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (destination['featureColor'] as Color).withOpacity(0.8),
                          (destination['featureColor'] as Color).withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: TravelPatternPainter(Colors.white.withOpacity(0.1)),
                          ),
                        ),
                        
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Destination name and favorite button
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      destination['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _destinations[index]['isFavorite'] = !destination['isFavorite'];
                                      });
                                    },
                                    child: Icon(
                                      destination['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ).animate(key: ValueKey('header-$index'))
                                .fadeIn(duration: 600.ms, delay: 200.ms)
                                .moveY(begin: -10, end: 0, duration: 600.ms, delay: 200.ms),
                              
                              const SizedBox(height: 8),
                              
                              // Description
                              Text(
                                destination['description'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ).animate(key: ValueKey('desc-$index'))
                                .fadeIn(duration: 600.ms, delay: 300.ms)
                                .moveY(begin: -10, end: 0, duration: 600.ms, delay: 300.ms),
                              
                              const Spacer(),
                              
                              // Rating and temperature
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
                                        '${destination['rating']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(width: 16),
                                  
                                  // Temperature
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.thermostat,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        destination['temperature'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const Spacer(),
                                  
                                  // Price
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'from ${destination['price']}',
                                      style: TextStyle(
                                        color: destination['featureColor'] as Color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate(key: ValueKey('details-$index'))
                                .fadeIn(duration: 600.ms, delay: 400.ms)
                                .moveY(begin: 10, end: 0, duration: 600.ms, delay: 400.ms),
                              
                              const SizedBox(height: 12),
                              
                              // Activities
                              Row(
                                children: (destination['activities'] as List).map((activity) => 
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      activity,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                              ).animate(key: ValueKey('activities-$index'))
                                .fadeIn(duration: 600.ms, delay: 500.ms)
                                .moveY(begin: 10, end: 0, duration: 600.ms, delay: 500.ms),
                            ],
                          ),
                        ),
                        
                        // Destination icon overlay
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Opacity(
                            opacity: 0.2,
                            child: Icon(
                              destination['image'] as IconData,
                              size: 140,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(duration: 800.ms, delay: 400.ms)
                    .moveY(begin: 30, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutQuad),
                );
              },
            ),
          ),
          
          // Popular destinations section
          Expanded(
            child: Column(
              children: [
                // Section header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _showFavorites ? 'Favorite Destinations' : 'Popular Destinations',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'View All',
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
                
                // Destinations list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _getFilteredDestinations().length,
                    itemBuilder: (context, index) {
                      final destination = _getFilteredDestinations()[index];
                      return Container(
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 12),
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
                            // Destination image/icon
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: (destination['featureColor'] as Color).withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  destination['image'] as IconData,
                                  size: 36,
                                  color: destination['featureColor'] as Color,
                                ),
                              ),
                            ),
                            
                            // Destination details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Name and rating
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            destination['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${destination['rating']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                Icons.thermostat,
                                                color: Colors.grey.shade600,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                destination['temperature'],
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Price and book button
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          destination['price'],
                                          style: TextStyle(
                                            color: widget.showcaseItem.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: widget.showcaseItem.color,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: widget.showcaseItem.color.withOpacity(0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            'BOOK',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
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

class TravelPatternPainter extends CustomPainter {
  final Color color;
  
  TravelPatternPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // Draw travel-themed pattern (map lines and dots)
    final pointRadius = size.width * 0.01;
    final lineSpacing = size.width * 0.1;
    
    // Draw horizontal and vertical lines (like a map grid)
    for (int i = 0; i < 15; i++) {
      final x = lineSpacing * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      
      if (i < 10) {
        final y = lineSpacing * i;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
    
    // Draw destination points (dots)
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if ((i + j) % 3 == 0) {
          final x = lineSpacing * (i + 1);
          final y = lineSpacing * (j + 1);
          canvas.drawCircle(Offset(x, y), pointRadius * 3, paint);
        }
      }
    }
    
    // Draw a few dashed route lines
    final routePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    _drawDashedLine(
      canvas, 
      Offset(lineSpacing, lineSpacing), 
      Offset(lineSpacing * 4, lineSpacing * 3), 
      routePaint
    );
    
    _drawDashedLine(
      canvas, 
      Offset(lineSpacing * 2, lineSpacing * 4), 
      Offset(lineSpacing * 5, lineSpacing * 2), 
      routePaint
    );
  }
  
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
    
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    final dashCount = (path.computeMetrics().first.length / (dashWidth + dashSpace)).floor();
    
    for (int i = 0; i < dashCount; i++) {
      final start = i * (dashWidth + dashSpace);
      canvas.drawPath(
        path.shift(Offset(0, 0)), 
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}