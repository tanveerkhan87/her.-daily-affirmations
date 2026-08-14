import 'package:flutter/material.dart';

/// Centralized color palette for the entire app.
/// Uses soft, calming tones for a modern, premium feel.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFE8729A);
  static const Color primaryLight = Color(0xFFF4A7C1);
  static const Color primaryDark = Color(0xFFBF4070);

  // Surfaces
  static const Color surfaceLight = Color(0xFFF9F5F6);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF252540);

  // Text
  static const Color textPrimaryLight = Color(0xFF2D2D3A);
  static const Color textSecondaryLight = Color(0xFF6B6B7B);
  static const Color textPrimaryDark = Color(0xFFF0F0F5);
  static const Color textSecondaryDark = Color(0xFF9E9EAE);

  // Accents
  static const Color accent = Color(0xFF7C5CFC);
  static const Color success = Color(0xFF4CAF7D);
  static const Color error = Color(0xFFE85D6F);
  static const Color warning = Color(0xFFF5A623);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE8729A), Color(0xFFF4A7C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFE8729A), Color(0xFFD4689B), Color(0xFF7C5CFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientA = LinearGradient(
    colors: [Color(0xFF7C5CFC), Color(0xFF5B8DEF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientB = LinearGradient(
    colors: [Color(0xFF4CAF7D), Color(0xFF7DCBA4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Misc
  static const Color shimmer = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE8E8EE);
  static const Color overlay = Color(0x40000000);
}
