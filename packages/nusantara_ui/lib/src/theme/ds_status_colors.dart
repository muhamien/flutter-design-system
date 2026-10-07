import 'package:flutter/material.dart';

// Semantic tokens tambahan; error tetap menggunakan ColorScheme.error.
@immutable
class DsStatusColors extends ThemeExtension<DsStatusColors> {
  const DsStatusColors({
    required this.successContainer,
    required this.onSuccessContainer,
  });

  final Color successContainer;
  final Color onSuccessContainer;

  factory DsStatusColors.forBrightness(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF216E39),
      brightness: brightness,
    );
    return DsStatusColors(
      successContainer: scheme.primaryContainer,
      onSuccessContainer: scheme.onPrimaryContainer,
    );
  }

  @override
  DsStatusColors copyWith({
    Color? successContainer,
    Color? onSuccessContainer,
  }) => DsStatusColors(
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
  );

  @override
  DsStatusColors lerp(covariant DsStatusColors? other, double t) {
    if (other == null) return this;
    return DsStatusColors(
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
    );
  }
}

extension DsThemeContext on BuildContext {
  DsStatusColors get dsStatus {
    final colors = Theme.of(this).extension<DsStatusColors>();
    if (colors == null) {
      throw FlutterError(
        'DsStatusColors belum terdaftar. Gunakan DsTheme.build.',
      );
    }
    return colors;
  }
}
