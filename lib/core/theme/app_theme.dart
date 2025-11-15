import 'package:flutter/material.dart';

/// App theme configuration with Material 3 design
class AppTheme {
  // Color palette (public for widget access)
  static const Color primary = Color(0xFF1976D2); // Blue 700
  static const Color primaryDark = Color(0xFF1565C0); // Blue 800
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color warning = Color(0xFFFF9800); // Orange 500
  static const Color error = Color(0xFFD32F2F); // Red 700
  static const Color onSurfaceVariant = Color(0xFF424242); // Gray 700

  // Private color palette for internal use
  static const Color _primary = primary;
  static const Color _primaryVariant = primaryDark;
  static const Color _secondary = Color(0xFF388E3C); // Green 700
  static const Color _secondaryVariant = Color(0xFF2E7D32); // Green 800

  // Neutral colors
  static const Color _surface = Color(0xFFFAFAFA); // Gray 50
  static const Color _background = Color(0xFFF5F5F5); // Gray 100
  static const Color _error = error;

  // Text colors
  static const Color _onPrimary = Colors.white;
  static const Color _onSecondary = Colors.white;
  static const Color _onSurface = Color(0xFF212121); // Gray 900
  static const Color _onBackground = Color(0xFF212121);
  static const Color _onError = Colors.white;

  // Spacing constants
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Border radius constants
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Shadow effects
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x331976D2),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // Color scheme for light theme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: _primaryVariant,
    onPrimaryContainer: _onPrimary,
    secondary: _secondary,
    onSecondary: _onSecondary,
    secondaryContainer: _secondaryVariant,
    onSecondaryContainer: _onSecondary,
    tertiary: Color(0xFFFF9800), // Orange 600
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEF6C00), // Orange 800
    onTertiaryContainer: Colors.white,
    error: _error,
    onError: _onError,
    errorContainer: Color(0xFFD32F2F),
    onErrorContainer: Colors.white,
    surface: _background,
    onSurface: _onBackground,
    surfaceContainerHighest: _surface,
    onSurfaceVariant: Color(0xFF424242), // Gray 700
    outline: Color(0xFFBDBDBD), // Gray 300
    outlineVariant: Color(0xFFE0E0E0), // Gray 200
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF303030),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFFBBDEFB), // Blue 200
  );

  // Color scheme for dark theme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF64B5F6), // Blue 300
    onPrimary: Color(0xFF0D47A1), // Blue 900
    primaryContainer: Color(0xFF1976D2), // Blue 700
    onPrimaryContainer: Colors.white,
    secondary: Color(0xFF81C784), // Green 300
    onSecondary: Color(0xFF1B5E20), // Green 900
    secondaryContainer: Color(0xFF388E3C), // Green 700
    onSecondaryContainer: Colors.white,
    tertiary: Color(0xFFFFB74D), // Orange 300
    onTertiary: Color(0xFFE65100), // Orange 900
    tertiaryContainer: Color(0xFFFF9800), // Orange 600
    onTertiaryContainer: Colors.white,
    error: Color(0xFFF44336), // Red 500
    onError: Color(0xFFB71C1C), // Red 900
    errorContainer: Color(0xFFD32F2F), // Red 700
    onErrorContainer: Colors.white,
    surface: Color(0xFF121212),
    onSurface: Color(0xFFE0E0E0), // Gray 300
    surfaceContainerHighest: Color(0xFF1E1E1E),
    onSurfaceVariant: Color(0xFFBDBDBD),
    outline: Color(0xFF757575), // Gray 500
    outlineVariant: Color(0xFF424242), // Gray 600
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Color(0xFF303030),
    inversePrimary: Color(0xFF1976D2), // Blue 700
  );

  // Text theme
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: _onSurface,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: _onSurface,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _onSurface,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF757575), // Gray 500
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: _onSurface,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: _onSurface,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: _onSurface,
    ),
  );

  // App bar theme
  static const AppBarTheme appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: _onSurface,
    ),
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: _onSurface,
    ),
  );

  // Card theme
  static const CardThemeData cardTheme = CardThemeData(
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  // Elevated button theme
  static final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );

  // Text button theme
  static final TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );

  // Outlined button theme
  static final OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );

  // Floating action button theme
  static const FloatingActionButtonThemeData floatingActionButtonTheme = FloatingActionButtonThemeData(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  // Bottom navigation bar theme
  static const BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
    elevation: 8,
    selectedItemColor: _primary,
    unselectedItemColor: Color(0xFF757575), // Gray 500
    type: BottomNavigationBarType.fixed,
  );

  // Input decoration theme
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F5F5), // Gray 100
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFBDBDBD)), // Gray 300
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFBDBDBD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: _primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: _error),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Get theme based on brightness
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: textTheme,
      appBarTheme: appBarTheme,
      cardTheme: cardTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      textButtonTheme: textButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      inputDecorationTheme: inputDecorationTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: textTheme.apply(
        bodyColor: const Color(0xFFE0E0E0), // Gray 300
        displayColor: const Color(0xFFE0E0E0),
      ),
      appBarTheme: appBarTheme.copyWith(
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0), // Gray 300
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFE0E0E0),
        ),
      ),
      cardTheme: cardTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      textButtonTheme: textButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
        selectedItemColor: const Color(0xFF64B5F6), // Blue 300
        unselectedItemColor: const Color(0xFF757575), // Gray 500
      ),
      inputDecorationTheme: inputDecorationTheme.copyWith(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
      ),
    );
  }
}

/// Custom color extensions for specific app features
extension AppColors on ColorScheme {
  // Status colors
  Color get success => const Color(0xFF4CAF50); // Green 500
  Color get warning => const Color(0xFFFF9800); // Orange 500
  Color get info => const Color(0xFF2196F3); // Blue 500
  Color get danger => const Color(0xFFF44336); // Red 500

  // Elevator specific colors
  Color get elevatorActive => success;
  Color get elevatorBusy => warning;
  Color get elevatorClosed => const Color(0xFF9E9E9E); // Gray 500
  Color get elevatorMaintenance => danger;

  // Timer status colors
  Color get timerActive => const Color(0xFF2196F3); // Blue 500
  Color get timerPaused => warning;
  Color get timerCompleted => success;
  Color get timerCancelled => danger;
}
