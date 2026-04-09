import 'package:flutter/material.dart';

class IslandSpot {
  const IslandSpot({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color accent;
}
