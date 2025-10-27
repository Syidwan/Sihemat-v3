import 'package:flutter/material.dart';

class MenuItem {
  final String id;
  final String label;
  final IconData? icon;     // optional
  final String? assetPath;  // optional
  final Color color;

  MenuItem({
    required this.id,
    required this.label,
    this.icon,
    this.assetPath,
    required this.color,
  });
}