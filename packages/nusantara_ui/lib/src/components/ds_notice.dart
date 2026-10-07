import 'package:flutter/material.dart';
import '../theme/ds_status_colors.dart';
import '../tokens/ds_tokens.dart';

enum DsNoticeTone { info, success, error }

class DsNotice extends StatelessWidget {
  const DsNotice({
    super.key,
    required this.message,
    this.tone = DsNoticeTone.info,
  });

  final String message;
  final DsNoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground, icon) = switch (tone) {
      DsNoticeTone.info => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        Icons.info_outline,
      ),
      DsNoticeTone.success => (
        context.dsStatus.successContainer,
        context.dsStatus.onSuccessContainer,
        Icons.check_circle_outline,
      ),
      DsNoticeTone.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.error_outline,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(DsSpace.md),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(DsRadius.control),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Icon(icon, color: foreground)),
            const SizedBox(width: DsSpace.sm),
            Expanded(
              child: Text(message, style: TextStyle(color: foreground)),
            ),
          ],
        ),
      ),
    );
  }
}
