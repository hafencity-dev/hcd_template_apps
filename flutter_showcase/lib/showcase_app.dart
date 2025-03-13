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

  // Mouse tracking properties
  Offset _mousePosition = Offset.zero;
  bool _isMouseInside = false;

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
        title: 'Fitness',
        description: 'Interaktive Diagramme und Statistiken',
        color: const Color(0xFF339966), // Medium green from palette
        icon: Icons.fitness_center_rounded,
        type: AppType.fitness,
      ),
      ShowcaseItem(
        title: 'Shop',
        description: 'Schöne UI mit flüssigen Animationen',
        color: const Color(0xFF6699CC), // Medium blue from palette
        icon: Icons.shopping_bag_rounded,
        type: AppType.ecommerce,
      ),
      ShowcaseItem(
        title: 'Banking',
        description: 'Modern UI with realistic card animations',
        color: const Color(0xFF48BB78), // N26-inspired teal color
        icon: Icons.account_balance_rounded,
        type: AppType.banking,
      ),
      ShowcaseItem(
        title: 'Essenslieferung',
        description: 'Ansprechende Animationen und einfache Navigation',
        color: const Color(0xFFFC8811), // Orange from vibrant palette
        icon: Icons.delivery_dining_rounded,
        type: AppType.foodDelivery,
      ),
      ShowcaseItem(
        title: 'Reisen',
        description: 'Immersives Erlebnis mit 3D-Effekten',
        color: const Color(0xFF2C8769), // Teal green from palette
        icon: Icons.travel_explore_rounded,
        type: AppType.travel,
      ),
      ShowcaseItem(
        title: 'Musik',
        description: 'Immersiver Player mit Audiovisualisierung',
        color: const Color(0xFFDEB71D), // Mustard yellow from palette
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
        });
      }
    });
  }

  // Method to scroll to the selected item - no longer needed with grid layout
  void _scrollToSelectedItem() {
    // No longer needed with grid layout
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
    // In mobile view, we want to force auto-switching regardless of user selection
    bool isMobileView = MediaQuery.of(context).size.width <= 600;
    if (isMobileView) {
      _userSelected = false; // Always auto-switch in mobile view
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Scaffold(
        body: MouseRegion(
          onEnter: (event) {
            setState(() {
              _isMouseInside = true;
              _mousePosition = event.position;
            });
          },
          onHover: (event) {
            setState(() {
              _mousePosition = event.position;
            });
          },
          onExit: (event) {
            setState(() {
              _isMouseInside = false;
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Interactive animated background
              InteractiveBackground(
                controller: _controller,
                externalMousePosition: _mousePosition,
                externalMouseInside: _isMouseInside,
              ),

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
        ),
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
          stops: const [0.0, 0.9, 1.0], // Adjusted stops for right-only fade
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }

  Widget _buildMobileLayout() {
    // For mobile, we only show the app screen that automatically switches
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 300, // Same width as desktop
          child: OverflowBox(
            maxHeight: double.infinity, // Allow overflow at bottom
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 9 / 18, // Same aspect ratio as desktop
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
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App items section - now a responsive grid with vertical scrolling
          Expanded(
            flex: 2,
            child: Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                clipBehavior: Clip.none,
                child: LayoutBuilder(builder: (context, constraints) {
                  // Calculate columns based on available width
                  // We want items to be at least 180px wide for desktop
                  final double itemWidth = 180;
                  final int columns =
                      (constraints.maxWidth / itemWidth).floor();
                  // Ensure we have at least 1 column, maximum 4 columns
                  final int crossAxisCount = columns.clamp(1, 5);

                  return StaggeredGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: List.generate(
                      _showcaseItems.length,
                      (index) => InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _previousItem = null;
                            _userSelected =
                                true; // User has manually selected an app
                          });
                        },
                        child: AppShowcaseItem(
                          showcaseItem: _showcaseItems[index],
                          isSelected: _selectedIndex == index,
                        ),
                      )
                          .animate()
                          .fade(duration: 600.ms, delay: (200 * index).ms)
                          .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.0, 1.0),
                              duration: 600.ms,
                              delay: (200 * index).ms),
                    ),
                  );
                }),
              ),
            ),
          ),

          // App preview section (1/3 of screen width)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      // Fixed width for phone display
                      width: 300,
                      child: OverflowBox(
                        maxHeight: double.infinity, // Allow overflow at bottom
                        alignment: Alignment.topCenter,
                        child: AspectRatio(
                          aspectRatio: 9 / 18, // Standard phone aspect ratio
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
                    ),
                  ),
                ],
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
    // No longer need to scroll to selected item with grid layout
  }
}
