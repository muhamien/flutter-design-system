import 'package:flutter/material.dart';
import '../tokens/ds_tokens.dart';

// Layout berdasarkan constraint lokal, bukan jenis perangkat.
class DsPage extends StatelessWidget {
  const DsPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final expanded = constraints.maxWidth >= DsLayout.expandedBreakpoint;
      return SingleChildScrollView(
        padding: EdgeInsets.all(expanded ? DsSpace.xl : DsSpace.md),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DsLayout.maxContentWidth,
            ),
            child: SizedBox(width: double.infinity, child: child),
          ),
        ),
      );
    },
  );
}
