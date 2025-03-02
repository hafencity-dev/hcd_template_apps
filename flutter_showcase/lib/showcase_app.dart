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

class _ShowcaseAppState extends State<ShowcaseApp> with SingleTickerProviderStateMixin {
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
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Flutter Excellence',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate()
                        .fade(duration: 800.ms)
                        .move(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                          duration: 800.ms,
                          curve: Curves.easeOutQuad,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Building beautiful, responsive, and feature-rich mobile experiences',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                        ),
                      ).animate()
                        .fade(duration: 800.ms, delay: 200.ms)
                        .move(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                          duration: 800.ms,
                          delay: 200.ms,
                          curve: Curves.easeOutQuad,
                        ),
                    ],
                  ),
                ),
                
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
          
          // Floating app screen for any view when an item is selected
          // App display with sequential animations
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            bottom: _hoveredIndex != -1 ? 20 : -700,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              opacity: _hoveredIndex != -1 ? 1.0 : 0.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: _hoveredIndex != -1 ? 1.0 : 0.8,
                curve: Curves.easeOutQuint,
                child: SizedBox(
                  width: 340,
                  height: 650,
                  child: _hoveredIndex != -1
                    ? FloatingAppScreen(
                        showcaseItem: _showcaseItems[_hoveredIndex],
                      )
                    : _previousItem != null
                      ? FloatingAppScreen(
                          showcaseItem: _previousItem!,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            onEnd: () {
              // If we're closing and there's a target index, open it now
              if (_isClosing && _targetIndex != -1) {
                setState(() {
                  _hoveredIndex = _targetIndex;
                  _targetIndex = -1;
                  _isClosing = false;
                });
              } else if (_isClosing) {
                setState(() {
                  _isClosing = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _showcaseItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (_hoveredIndex == -1 && !_isClosing) {
                // No app open, simple open animation
                setState(() {
                  _hoveredIndex = index;
                  _previousItem = null;
                });
              } else if (_hoveredIndex == index) {
                // Close the current app
                setState(() {
                  _previousItem = _showcaseItems[_hoveredIndex];
                  _hoveredIndex = -1;
                  _isClosing = true;
                  _targetIndex = -1; // No follow-up app to open
                });
              } else {
                // Switch from one app to another with sequential animation
                setState(() {
                  _previousItem = _showcaseItems[_hoveredIndex];
                  _targetIndex = index; // App to open after closing
                  _hoveredIndex = -1;
                  _isClosing = true;
                });
              }
            },
            child: AppShowcaseItem(
              showcaseItem: _showcaseItems[index],
              isSelected: _hoveredIndex == index,
            ),
          ),
        ).animate()
          .fade(duration: 600.ms, delay: (200 * index).ms)
          .move(
            begin: const Offset(0, 0.2), 
            end: Offset.zero, 
            duration: 600.ms, 
            delay: (200 * index).ms,
            curve: Curves.easeOutQuad,
          );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: MasonryGridView.count(
        crossAxisCount: ResponsiveValue<int>(
          context,
          defaultValue: 2,
          conditionalValues: [
            const Condition.largerThan(name: TABLET, value: 3),
            const Condition.largerThan(name: DESKTOP, value: 4),
          ],
        ).value,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: _showcaseItems.length,
        itemBuilder: (context, index) {
          return MouseRegion(
            onEnter: (_) {
              if (_hoveredIndex == -1 && !_isClosing) {
                // No app open, simple open animation
                setState(() {
                  _hoveredIndex = index;
                  _previousItem = null;
                });
              } else if (_hoveredIndex != index) {
                // If we're already closing and going to a new target, just update target
                if (_isClosing) {
                  setState(() {
                    _targetIndex = index;
                  });
                  return;
                }
                
                // Start the closing animation with a target to open next
                setState(() {
                  _previousItem = _showcaseItems[_hoveredIndex];
                  _targetIndex = index; // App to open after closing
                  _hoveredIndex = -1;
                  _isClosing = true;
                });
              }
            },
            onExit: (_) {
              // If this is our target for the next open and we're moving away
              if (_targetIndex == index) {
                setState(() {
                  _targetIndex = -1; // Clear the target
                });
              }
              
              // If this is the currently open app, close it
              if (_hoveredIndex == index && !_isClosing) {
                setState(() {
                  _previousItem = _showcaseItems[_hoveredIndex];
                  _hoveredIndex = -1;
                  _isClosing = true;
                  _targetIndex = -1;
                });
              }
            },
            child: AppShowcaseItem(
              showcaseItem: _showcaseItems[index],
              isSelected: _hoveredIndex == index,
            ),
          ).animate()
            .fade(duration: 600.ms, delay: (200 * index).ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 600.ms, delay: (200 * index).ms);
        },
      ),
    );
  }
}