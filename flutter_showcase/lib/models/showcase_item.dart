import 'package:flutter/material.dart';

enum AppType {
  ecommerce,
  banking,
  fitness,
  foodDelivery,
  travel,
  music,
  recipe,
  projectManagement,
  generic
}

class ShowcaseItem {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final AppType type;

  ShowcaseItem({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.type,
  });
}
