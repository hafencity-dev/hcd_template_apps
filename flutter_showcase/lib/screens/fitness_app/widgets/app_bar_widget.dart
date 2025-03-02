import 'package:flutter/material.dart';

class FitnessAppBar extends StatelessWidget {
  final Color darkBgColor;
  final LinearGradient primaryGradient;
  final TabController tabController;
  final Color accentColor;
  final Color mainColor;

  const FitnessAppBar({
    super.key,
    required this.darkBgColor,
    required this.primaryGradient,
    required this.tabController,
    required this.accentColor,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'PULSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'FIT',
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: () {},
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: darkBgColor, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
