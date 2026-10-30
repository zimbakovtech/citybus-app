import 'package:flutter/material.dart';

/// Design tokens — single source of truth for spacing and shape so every
/// screen shares the same rhythm.
abstract final class Insets {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Standard horizontal page padding.
  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: lg);
}

abstract final class Radii {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
}

// Flat design palette (transit blue + slate neutrals). Light and dark are
// designed as a pair; components only ever use the scheme's semantic roles.
const _blue600 = Color(0xFF2563EB);
const _blue400 = Color(0xFF60A5FA);
const _blue100 = Color(0xFFDBEAFE);
const _blue900 = Color(0xFF1E3A8A);
const _teal600 = Color(0xFF0891B2);
const _teal100 = Color(0xFFCFFAFE);
const _teal900 = Color(0xFF164E63);
const _slate50 = Color(0xFFF8FAFC);
const _slate100 = Color(0xFFF1F5F9);
const _slate200 = Color(0xFFE2E8F0);
const _slate400 = Color(0xFF94A3B8);
const _slate500 = Color(0xFF64748B);
const _slate700 = Color(0xFF334155);
const _slate800 = Color(0xFF1E293B);
const _slate900 = Color(0xFF0F172A);
const _slate950 = Color(0xFF0B1220);

const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: _blue600,
  onPrimary: Colors.white,
  primaryContainer: _blue100,
  onPrimaryContainer: _blue900,
  secondary: _teal600,
  onSecondary: Colors.white,
  secondaryContainer: _teal100,
  onSecondaryContainer: _teal900,
  error: Color(0xFFDC2626),
  onError: Colors.white,
  errorContainer: Color(0xFFFEE2E2),
  onErrorContainer: Color(0xFF7F1D1D),
  surface: Colors.white,
  onSurface: _slate900,
  onSurfaceVariant: _slate500,
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: _slate50,
  surfaceContainer: _slate50,
  surfaceContainerHigh: _slate100,
  surfaceContainerHighest: _slate100,
  outline: _slate400,
  outlineVariant: _slate200,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: _slate900,
  onInverseSurface: _slate50,
  inversePrimary: _blue400,
);

const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _blue400,
  onPrimary: _slate950,
  primaryContainer: _blue900,
  onPrimaryContainer: _blue100,
  secondary: Color(0xFF22D3EE),
  onSecondary: _slate950,
  secondaryContainer: _teal900,
  onSecondaryContainer: _teal100,
  error: Color(0xFFF87171),
  onError: _slate950,
  errorContainer: Color(0xFF7F1D1D),
  onErrorContainer: Color(0xFFFEE2E2),
  surface: _slate800,
  onSurface: _slate50,
  onSurfaceVariant: _slate400,
  surfaceContainerLowest: _slate950,
  surfaceContainerLow: _slate900,
  surfaceContainer: _slate900,
  surfaceContainerHigh: _slate700,
  surfaceContainerHighest: _slate700,
  outline: _slate500,
  outlineVariant: _slate700,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: _slate50,
  onInverseSurface: _slate900,
  inversePrimary: _blue600,
);

TextTheme _textTheme(ColorScheme scheme) {
  TextStyle style(double size, FontWeight weight, {double? height}) =>
      TextStyle(
        fontFamily: 'Outfit',
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: scheme.onSurface,
      );

  return TextTheme(
    displaySmall: style(34, FontWeight.w800, height: 1.15),
    headlineMedium: style(28, FontWeight.w800, height: 1.2),
    headlineSmall: style(24, FontWeight.w700, height: 1.25),
    titleLarge: style(20, FontWeight.w700, height: 1.3),
    titleMedium: style(16, FontWeight.w700, height: 1.35),
    titleSmall: style(14, FontWeight.w600, height: 1.4),
    bodyLarge: style(16, FontWeight.w400, height: 1.5),
    bodyMedium: style(14, FontWeight.w400, height: 1.5),
    bodySmall: style(12, FontWeight.w400, height: 1.45),
    labelLarge: style(14, FontWeight.w600, height: 1.4),
    labelMedium: style(12, FontWeight.w600, height: 1.35),
    labelSmall: style(11, FontWeight.w500, height: 1.3),
  );
}

ThemeData buildTheme(Brightness brightness) {
  final scheme = brightness == Brightness.light ? _lightScheme : _darkScheme;
  final text = _textTheme(scheme);

  RoundedRectangleBorder shape(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Outfit',
    textTheme: text,
    scaffoldBackgroundColor: scheme.surfaceContainerLow,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: scheme.surfaceContainerLow,
      foregroundColor: scheme.onSurface,
      titleTextStyle: text.titleLarge,
    ),
    // flat design: one card style everywhere — no shadow, hairline border
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surface,
      shape: shape(Radii.lg)
          .copyWith(side: BorderSide(color: scheme.outlineVariant)),
      clipBehavior: Clip.antiAlias,
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(scheme.surface),
      shape: WidgetStatePropertyAll(
        shape(Radii.md)
            .copyWith(side: BorderSide(color: scheme.outlineVariant)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: Insets.lg),
      ),
      textStyle: WidgetStatePropertyAll(text.bodyLarge),
      hintStyle: WidgetStatePropertyAll(
        text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
      ),
    ),
    // segmented-control-style tabs (used with the shared SegmentedTabBar)
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      labelColor: scheme.onPrimary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      labelStyle: text.labelLarge,
      unselectedLabelStyle: text.labelLarge,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: shape(Radii.md),
        minimumSize: const Size.fromHeight(52),
        textStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      elevation: 0,
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer,
      indicatorShape: shape(Radii.sm),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : scheme.onSurfaceVariant,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => text.labelMedium?.copyWith(
          color: states.contains(WidgetState.selected)
              ? scheme.onSurface
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: shape(Radii.sm),
      side: BorderSide(color: scheme.outlineVariant),
      backgroundColor: scheme.surface,
      labelStyle: text.labelMedium,
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      minVerticalPadding: Insets.md,
      iconColor: scheme.onSurfaceVariant,
    ),
  );
}

/// Parses a GTFS route color ('D32F2F', no '#') with a fallback.
Color routeColor(String? hex) {
  if (hex == null || hex.length != 6) return _blue600;
  final value = int.tryParse(hex, radix: 16);
  return value == null ? _blue600 : Color(0xFF000000 | value);
}
