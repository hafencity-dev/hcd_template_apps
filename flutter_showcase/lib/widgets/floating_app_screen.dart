import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/showcase_item.dart';
import '../screens/ecommerce_app.dart';
import '../screens/banking_app.dart';
import '../screens/fitness_app.dart';
import '../screens/food_delivery_app.dart';
import '../screens/travel_app.dart';
import '../screens/music_app.dart';

class FloatingAppScreen extends StatelessWidget {
  final ShowcaseItem showcaseItem;

  const FloatingAppScreen({
    super.key,
    required this.showcaseItem,
  });

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
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutQuint,
                        reverseCurve: Curves.easeInQuint,
                      ),
                      child: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutExpo,
                        ).drive(Tween<double>(begin: 0.9, end: 1.0)),
                        child: child,
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
                    key: ValueKey<String>(showcaseItem.title),
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
            color: Colors.black.withOpacity(0.3),
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
    // Select the appropriate app UI based on the showcase item
    switch (showcaseItem.title) {
      case 'E-Commerce App':
        return ECommerceAppScreen(showcaseItem: showcaseItem);
      case 'Banking App':
        return BankingAppScreen(showcaseItem: showcaseItem);
      case 'Fitness Tracker':
        return FitnessAppScreen(showcaseItem: showcaseItem);
      case 'Food Delivery':
        return FoodDeliveryAppScreen(showcaseItem: showcaseItem);
      case 'Travel App':
        return TravelAppScreen(showcaseItem: showcaseItem);
      case 'Music App':
        return MusicAppScreen(showcaseItem: showcaseItem);
      default:
        return _buildGenericApp();
    }
  }

  Widget _buildGenericApp() {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showcaseItem.icon,
              size: 60,
              color: showcaseItem.color,
            ),
            const SizedBox(height: 16),
            Text(
              showcaseItem.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              showcaseItem.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}