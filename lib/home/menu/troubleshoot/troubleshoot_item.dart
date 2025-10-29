import 'package:flutter/material.dart';

class TroubleshootItem {
  final String id;
  final String title;
  final IconData icon;
  final String? pdfUrl;      // URL online
  final String? pdfAsset;    // Path asset lokal

  const TroubleshootItem({
    required this.id,
    required this.title,
    required this.icon,
    this.pdfUrl,
    this.pdfAsset,
  });
}