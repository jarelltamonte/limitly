import 'package:flutter/material.dart';

class UnifiedTransaction {
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final IconData icon;
  final bool isSavings;

  UnifiedTransaction({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
    required this.isSavings,
  });
}
