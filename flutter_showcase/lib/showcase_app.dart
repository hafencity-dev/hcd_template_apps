import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';

import 'widgets/app_showcase_item.dart';
import 'widgets/floating_app_screen.dart';
import 'widgets/interactive_background.dart';
import 'models/showcase_item.dart';

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<ShowcaseItem> _showcaseItems;
  int _selectedIndex = 0; // Default to Fitness (now first item)
  ShowcaseItem? _previousItem;
  bool _isClosing = false; // Track when we're in the closing phase

  // Auto switching properties
  Timer? _autoSwitchTimer;
  bool _userSelected = false; // Track if user has manually selected an app

  // Scroll controllers for both layouts
  final ScrollController _mobileScrollController = ScrollController();
  final ScrollController _desktopScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _showcaseItems = [
      // Fitness is now the first item
      ShowcaseItem(
        title: 'Fitness Tracker',
        description: 'Interaktive Diagramme und Statistiken',
        color: Colors.green.shade600,
        icon: Icons.fitness_center_rounded,
        type: AppType.fitness,
      ),
      ShowcaseItem(
        title: 'E-Commerce App',
        description: 'Schöne UI mit flüssigen Animationen',
        color: Colors.blue.shade700,
        icon: Icons.shopping_bag_rounded,
        type: AppType.ecommerce,
      ),
      ShowcaseItem(
        title: 'Banking App',
        description: 'Sicheres und responsives Design',
        color: Colors.purple.shade700,
        icon: Icons.account_balance_rounded,
        type: AppType.banking,
      ),
      ShowcaseItem(
        title: 'Essenslieferung',
        description: 'Ansprechende Animationen und einfache Navigation',
        color: Colors.orange.shade700,
        icon: Icons.delivery_dining_rounded,
        type: AppType.foodDelivery,
      ),
      ShowcaseItem(
        title: 'Reise App',
        description: 'Immersives Erlebnis mit 3D-Effekten',
        color: Colors.teal.shade700,
        icon: Icons.travel_explore_rounded,
        type: AppType.travel,
      ),
      ShowcaseItem(
        title: 'Musik App',
        description: 'Immersiver Player mit Audiovisualisierung',
        color: Colors.pink.shade700,
        icon: Icons.music_note_rounded,
        type: AppType.music,
      ),
    ];

    // Start auto switching timer
    _startAutoSwitchTimer();
  }

  void _startAutoSwitchTimer() {
    _autoSwitchTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Only auto-switch if user hasn't manually selected an app
      if (!_userSelected && mounted) {
        setState(() {
          // Move to next app, loop back to start when we reach the end
          _selectedIndex = (_selectedIndex + 1) % _showcaseItems.length;

          // Scroll to make the newly selected item visible
          _scrollToSelectedItem();
        });
      }
    });
  }

  // Method to scroll to the selected item
  void _scrollToSelectedItem() {
    // Calculate approximate position of the selected item
    double itemWidth = MediaQuery.of(context).size.width > 600
        ? 296.0
        : 236.0; // width + padding
    double scrollOffset = _selectedIndex * itemWidth;

    // Scroll mobile layout - with smoother animation
    if (_mobileScrollController.hasClients) {
      _mobileScrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }

    // Scroll desktop layout - with smoother animation
    if (_desktopScrollController.hasClients) {
      _desktopScrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoSwitchTimer?.cancel();
    _mobileScrollController.dispose();
    _desktopScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Interactive animated background
          InteractiveBackground(controller: _controller),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Showcase content
                Expanded(
                  child: ResponsiveValue<Widget>(
                    context,
                    defaultValue: _buildMobileLayout(),
                    conditionalValues: [
                      Condition.largerThan(
                        name: MOBILE,
                        value: _buildDesktopLayout(),
                      )
                    ],
                  ).value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Edge gradient for lists
  Widget _buildEdgeGradientMask({required Widget child}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white
                .withOpacity(1.0), // Left edge now fully opaque (no fade)
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(0.0), // Right edge still has fade
          ],
          stops: const [0.0, 0.85, 1.0], // Adjusted stops for right-only fade
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }

  Widget _buildMobileLayout() {
    // For mobile, we stack the components vertically
    // App items on top (larger part) and app screen on bottom
    return Column(
      children: [
        // App items section - now a single row with horizontal scroll
        SizedBox(
          height: 150, // Fixed height for the row
          child: _buildEdgeGradientMask(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _mobileScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _showcaseItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 220, // Fixed width for each card
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                          _previousItem = null;
                          _userSelected =
                              true; // User has manually selected an app

                          // No need to scroll here as the tapped item is already visible
                        });
                      },
                      child: AppShowcaseItem(
                        showcaseItem: _showcaseItems[index],
                        isSelected: _selectedIndex == index,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 600.ms, delay: (200 * index).ms)
                    .move(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                      duration: 600.ms,
                      delay: (200 * index).ms,
                      curve: Curves.easeOutQuad,
                    );
              },
            ),
          ),
        ),

        // App preview section (rest of the screen)
        Expanded(
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: 1.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: 1.0,
                curve: Curves.easeOutQuint,
                child: SizedBox(
                  width: 200, // Smaller for mobile layout
                  height: double.infinity,
                  child: FloatingAppScreen(
                    showcaseItem: _showcaseItems[_selectedIndex],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App items section - now a single row with horizontal scroll
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: SizedBox(
                height: 180, // Fixed height for the row
                child: _buildEdgeGradientMask(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _desktopScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _showcaseItems.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 280, // Fixed width for each card
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                                _previousItem = null;
                                _userSelected =
                                    true; // User has manually selected an app

                                // No need to scroll here as the tapped item is already visible
                              });
                            },
                            child: AppShowcaseItem(
                              showcaseItem: _showcaseItems[index],
                              isSelected: _selectedIndex == index,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fade(duration: 600.ms, delay: (200 * index).ms)
                          .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.0, 1.0),
                              duration: 600.ms,
                              delay: (200 * index).ms);
                    },
                  ),
                ),
              ),
            ),
          ),

          // App preview section (1/3 of screen width)
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AspectRatio(
                        aspectRatio: 9 / 19.5, // iPhone aspect ratio
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1.0,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 400),
                            scale: 1.0,
                            curve: Curves.easeOutQuint,
                            child: FloatingAppScreen(
                              showcaseItem: _showcaseItems[_selectedIndex],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When dependencies change (like screen size), ensure selected item is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedItem();
    });
  }
}
