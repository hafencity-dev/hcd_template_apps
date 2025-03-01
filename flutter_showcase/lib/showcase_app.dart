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
          if (_hoveredIndex != -1)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingAppScreen(
                showcaseItem: _showcaseItems[_hoveredIndex],
              ),
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
              setState(() {
                _hoveredIndex = _hoveredIndex == index ? -1 : index;
              });
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
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
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