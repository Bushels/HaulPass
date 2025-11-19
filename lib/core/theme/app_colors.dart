import 'package:flutter/material.dart';

/// HaulPass color palette - Slate & Amber aesthetic
///
/// This theme matches the industrial, modern design language
/// inspired by the landing page design.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ==================== Slate Colors ====================
  /// Lightest slate - used for backgrounds
  static const slate50 = Color(0xFFF8FAFC);

  /// Light slate - used for borders and dividers
  static const slate200 = Color(0xFFE2E8F0);

  /// Medium slate - used for subtle borders
  static const slate300 = Color(0xFFCBD5E1);

  /// Slate for secondary text and icons
  static const slate400 = Color(0xFF94A3B8);

  /// Slate for muted text
  static const slate500 = Color(0xFF64748B);

  /// Darker slate for body text
  static const slate600 = Color(0xFF475569);

  /// Dark slate for card headers and accents
  static const slate800 = Color(0xFF1E293B);

  /// Darkest slate - used for headers and primary text
  static const slate900 = Color(0xFF0F172A);

  // ==================== Amber Colors ====================
  /// Amber for highlights and hover states
  static const amber100 = Color(0xFFFEF3C7);

  /// Primary amber accent color
  static const amber500 = Color(0xFFF59E0B);

  /// Darker amber for buttons and CTAs
  static const amber600 = Color(0xFFD97706);

  // ==================== Status Colors ====================
  /// Success green (light)
  static const green400 = Color(0xFF4ADE80);

  /// Success green (standard)
  static const green500 = Color(0xFF22C55E);

  /// Success green (dark)
  static const green600 = Color(0xFF16A34A);

  /// Warning/moderate status
  static const yellow500 = Color(0xFFEAB308);

  /// Error/danger red
  static const red500 = Color(0xFFEF4444);

  /// Error/danger red (dark)
  static const red600 = Color(0xFFDC2626);

  // ==================== Semantic Colors ====================
  /// Primary brand color
  static const primary = amber600;

  /// Success state color
  static const success = green600;

  /// Warning state color
  static const warning = amber500;

  /// Danger/error state color
  static const danger = red500;

  /// Background color for the app
  static const background = slate50;

  /// Surface color for cards
  static const surface = Colors.white;

  /// Border color for cards and containers
  static const border = slate200;

  /// Divider color
  static const divider = slate200;

  // ==================== Legacy Color Aliases (Backward Compatibility) ====================
  /// @deprecated Use amber600 instead
  static const primaryBlue = amber600;

  /// @deprecated Use amber500 instead
  static const primaryBlueDark = amber500;

  /// @deprecated Use amber600 instead
  static const primaryBlueLight = amber600;

  /// @deprecated Use green600 instead
  static const accentGreen = green600;

  /// @deprecated Use green600 instead
  static const accentGreenDark = green600;

  /// @deprecated Use green400 instead
  static const accentGreenLight = green400;

  /// @deprecated Use amber600 instead
  static const accentOrange = amber600;

  /// @deprecated Use amber600 instead
  static const accentOrangeDark = amber600;

  /// @deprecated Use amber500 instead
  static const accentOrangeLight = amber500;

  /// @deprecated Use red500 instead
  static const error = red500;

  /// @deprecated Use amber600 instead
  static const info = amber600;

  // ==================== Text Colors ====================
  /// Primary text color
  static const textPrimary = slate900;

  /// Secondary text color
  static const textSecondary = slate600;

  /// Muted text color
  static const textMuted = slate500;

  /// Disabled text color
  static const textDisabled = slate400;

  /// Text on dark backgrounds
  static const textOnDark = Colors.white;

  // ==================== Shadows for depth ====================
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> amberGlow(double opacity) => [
        BoxShadow(
          color: amber600.withOpacity(opacity),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}
