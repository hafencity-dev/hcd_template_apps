import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  int _hoveredIndex = -1;
  int _targetIndex = -1; // This is the index we're transitioning to
  ShowcaseItem? _previousItem;
  bool _isClosing = false; // Track when we're in the closing phase

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _showcaseItems = [
      ShowcaseItem(
        title: 'E-Commerce App',
        description: 'Beautiful UI with smooth animations',
        color: Colors.blue.shade700,
        icon: Icons.shopping_bag_rounded,
      ),
      ShowcaseItem(
        title: 'Fitness Tracker',
        description: 'Interactive charts and statistics',
        color: Colors.green.shade600,
        icon: Icons.fitness_center_rounded,
      ),
      ShowcaseItem(
        title: 'Banking App',
        description: 'Secure and responsive design',
        color: Colors.purple.shade700,
        icon: Icons.account_balance_rounded,
      ),
      ShowcaseItem(
        title: 'Food Delivery',
        description: 'Engaging animations and easy navigation',
        color: Colors.orange.shade700,
        icon: Icons.delivery_dining_rounded,
      ),
      ShowcaseItem(
        title: 'Travel App',
        description: 'Immersive experience with 3D effects',
        color: Colors.teal.shade700,
        icon: Icons.travel_explore_rounded,
      ),
      ShowcaseItem(
        title: 'Music App',
        description: 'Immersive player with audio visualization',
        color: Colors.pink.shade700,
        icon: Icons.music_note_rounded,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
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

  Widget _buildMobileLayout() {
    // For mobile, we stack the components vertically
    // App items on top (larger part) and app screen on bottom
    return Column(
      children: [
        // App items section (2/3 of screen height)
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _showcaseItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _hoveredIndex = index;
                      _previousItem = null;
                    });
                  },
                  child: AppShowcaseItem(
                    showcaseItem: _showcaseItems[index],
                    isSelected: _hoveredIndex == index,
                  ),
                ),
              ).animate().fade(duration: 600.ms, delay: (200 * index).ms).move(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                    duration: 600.ms,
                    delay: (200 * index).ms,
                    curve: Curves.easeOutQuad,
                  );
            },
          ),
        ),

        // App preview section (1/3 of screen height)
        Expanded(
          flex: 1,
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _hoveredIndex != -1 ? 1.0 : 0.5,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: _hoveredIndex != -1 ? 1.0 : 0.9,
                curve: Curves.easeOutQuint,
                child: SizedBox(
                  width: 200, // Smaller for mobile layout
                  height: double.infinity,
                  child: _hoveredIndex != -1
                      ? FloatingAppScreen(
                          showcaseItem: _showcaseItems[_hoveredIndex],
                        )
                      : _previousItem != null
                          ? FloatingAppScreen(
                              showcaseItem: _previousItem!,
                            )
                          : FloatingAppScreen(
                              showcaseItem: _showcaseItems[0],
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
    return Row(
      children: [
        // App items section (2/3 of screen width)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MasonryGridView.count(
              crossAxisCount: ResponsiveValue<int>(
                context,
                defaultValue: 2,
                conditionalValues: [
                  const Condition.largerThan(name: TABLET, value: 3),
                  const Condition.largerThan(
                      name: DESKTOP, value: 3), // Reduced max columns to 3
                ],
              ).value,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: _showcaseItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _hoveredIndex = index;
                      _previousItem = null;
                    });
                  },
                  onHover: (isHovering) {
                    if (isHovering) {
                      setState(() {
                        _hoveredIndex = index;
                        _previousItem = null;
                      });
                    }
                  },
                  child: AppShowcaseItem(
                    showcaseItem: _showcaseItems[index],
                    isSelected: _hoveredIndex == index,
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

        // App preview section (1/3 of screen width)
        Expanded(
          flex: 1,
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _hoveredIndex != -1 ? 1.0 : 0.5,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: _hoveredIndex != -1 ? 1.0 : 0.9,
                curve: Curves.easeOutQuint,
                child: SizedBox(
                  width: 300,
                  height: 600,
                  child: _hoveredIndex != -1
                      ? FloatingAppScreen(
                          showcaseItem: _showcaseItems[_hoveredIndex],
                        )
                      : _previousItem != null
                          ? FloatingAppScreen(
                              showcaseItem: _previousItem!,
                            )
                          : FloatingAppScreen(
                              showcaseItem: _showcaseItems[0],
                            ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
