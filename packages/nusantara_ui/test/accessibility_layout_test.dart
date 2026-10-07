import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_ui/nusantara_ui.dart';

void main() {
  testWidgets('primary button meets Android touch target guideline', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: DsTheme.build(),
          home: Scaffold(
            body: Center(
              child: DsButton(label: 'Simpan', onPressed: () {}),
            ),
          ),
        ),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });

  for (final brightness in Brightness.values) {
    testWidgets('narrow layout supports large text in $brightness', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: DsTheme.build(brightness: brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: DsPage(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DsButton(
                    label: 'Simpan perubahan profil pengguna',
                    onPressed: () {},
                  ),
                  const SizedBox(height: DsSpace.md),
                  const DsNotice(
                    message:
                        'Data berhasil disimpan dan dapat diperiksa kembali.',
                    tone: DsNoticeTone.success,
                  ),
                  const SizedBox(height: DsSpace.md),
                  const DsTextField(
                    label: 'Nama lengkap',
                    helperText: 'Nama yang akan ditampilkan di profil.',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
