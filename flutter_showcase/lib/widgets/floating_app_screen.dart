import 'package:flutter/material.dart';

import '../models/showcase_item.dart';
// Using deferred imports to improve initial load times
import '../screens/ecommerce_app.dart' deferred as ecommerce;
import '../screens/banking_app.dart' deferred as banking;
import '../screens/fitness_app.dart' deferred as fitness;
import '../screens/food_delivery_app.dart' deferred as food_delivery;
import '../screens/travel_app.dart' deferred as travel;
import '../screens/music_app.dart' deferred as music;

class FloatingAppScreen extends StatefulWidget {
  final ShowcaseItem showcaseItem;

  const FloatingAppScreen({
    super.key,
    required this.showcaseItem,
  });

  @override
  State<FloatingAppScreen> createState() => _FloatingAppScreenState();
}

class _FloatingAppScreenState extends State<FloatingAppScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  @override
  void didUpdateWidget(FloatingAppScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showcaseItem.type != widget.showcaseItem.type) {
      setState(() {
        _isLoading = true;
      });
      _loadLibrary();
    }
  }

  Future<void> _loadLibrary() async {
    switch (widget.showcaseItem.type) {
      case AppType.ecommerce:
        await ecommerce.loadLibrary();
        break;
      case AppType.banking:
        await banking.loadLibrary();
        break;
      case AppType.fitness:
        await fitness.loadLibrary();
        break;
      case AppType.foodDelivery:
        await food_delivery.loadLibrary();
        break;
      case AppType.travel:
        await travel.loadLibrary();
        break;
      case AppType.music:
        await music.loadLibrary();
        break;
      case AppType.generic:
        // No library to load for generic case
        break;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 650,
      child: Stack(
        children: [
          // Phone frame
          _buildPhoneFrame(),

          // App screen content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    // Create a combined animation that's both efficient and smooth
                    // Use the standard Flutter animation primitives to avoid unnecessary rebuilds
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                        reverseCurve: Curves.easeInCubic,
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 1.1,
                            end: 1.0,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                      ),
                    );
                  },
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<String>(widget.showcaseItem.title),
                    child: _buildAppContent(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneFrame() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Screen bezel
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
            ),
          ),

          // Notch
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 120,
              height: 25,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppContent() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    // Select the appropriate app UI based on the showcase item type
    switch (widget.showcaseItem.type) {
      case AppType.ecommerce:
        return ecommerce.ECommerceAppScreen(showcaseItem: widget.showcaseItem);
      case AppType.banking:
        return banking.BankingAppScreen(showcaseItem: widget.showcaseItem);
      case AppType.fitness:
        return fitness.FitnessAppScreen(showcaseItem: widget.showcaseItem);
      case AppType.foodDelivery:
        return food_delivery.FoodDeliveryAppScreen(
            showcaseItem: widget.showcaseItem);
      case AppType.travel:
        return travel.TravelAppScreen(showcaseItem: widget.showcaseItem);
      case AppType.music:
        return music.MusicAppScreen(showcaseItem: widget.showcaseItem);
      case AppType.generic:
        return _buildGenericApp();
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lädt...",
              style: TextStyle(
                color: widget.showcaseItem.color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericApp() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.showcaseItem.icon,
              size: 60,
              color: widget.showcaseItem.color,
            ),
            const SizedBox(height: 16),
            Text(
              widget.showcaseItem.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.showcaseItem.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
