import 'package:flutter/material.dart';
import '../tokens/ds_tokens.dart';

enum DsButtonVariant { primary, secondary, tertiary }

// Wrapper menstandarkan intent dan loading; warna/state tetap ditangani Material.
class DsButton extends StatelessWidget {
  const DsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DsButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final callback = isLoading ? null : onPressed;
    final Widget child;
    if (isLoading) {
      child = Semantics(
        label: '$label, sedang diproses',
        liveRegion: true,
        child: ExcludeSemantics(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: DsSpace.sm,
            children: [
              SizedBox.square(
                dimension: DsSpace.md,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    } else {
      child = Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: DsSpace.sm,
        children: [
          if (icon != null) Icon(icon, size: 20),
          Text(label, textAlign: TextAlign.center),
        ],
      );
    }
    return switch (variant) {
      DsButtonVariant.primary => FilledButton(
        onPressed: callback,
        child: child,
      ),
      DsButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        child: child,
      ),
      DsButtonVariant.tertiary => TextButton(onPressed: callback, child: child),
    };
  }
}
