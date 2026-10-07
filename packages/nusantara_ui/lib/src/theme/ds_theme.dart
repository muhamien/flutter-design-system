import 'package:flutter/material.dart';
import '../tokens/ds_tokens.dart';
import 'ds_status_colors.dart';

abstract final class DsTheme {
  static ThemeData build({
    Brightness brightness = Brightness.light,
    DsBrand brand = DsBrand.ocean,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: brand.seed,
      brightness: brightness,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DsRadius.control),
    );
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(DsLayout.minTouchTarget, DsLayout.minTouchTarget),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: DsSpace.lg, vertical: DsSpace.sm),
      ),
      shape: WidgetStatePropertyAll(controlShape),
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(DsRadius.control),
      borderSide: BorderSide(color: scheme.outline),
    );
    return base.copyWith(
      extensions: [DsStatusColors.forBrightness(brightness)],
      scaffoldBackgroundColor: scheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      textButtonTheme: TextButtonThemeData(style: buttonStyle),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.all(DsSpace.md),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsRadius.card),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
