import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_ui/nusantara_ui.dart';

void main() {
  test('Status extension terdaftar pada kedua brightness', () {
    for (final brightness in Brightness.values) {
      final theme = DsTheme.build(brightness: brightness);
      expect(theme.brightness, brightness);
      expect(theme.extension<DsStatusColors>(), isNotNull);
    }
    final light = DsTheme.build().extension<DsStatusColors>()!;
    final dark = DsTheme.build(
      brightness: Brightness.dark,
    ).extension<DsStatusColors>()!;
    expect(light.lerp(dark, 0).successContainer, light.successContainer);
    expect(light.lerp(dark, 1).successContainer, dark.successContainer);
  });

  testWidgets('Loading mencegah submit ulang', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: DsTheme.build(),
        home: Scaffold(
          body: DsButton(
            label: 'Simpan',
            isLoading: true,
            onPressed: () => count++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(count, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Form meneruskan validator milik fitur', (tester) async {
    final key = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        theme: DsTheme.build(),
        home: Scaffold(
          body: Form(
            key: key,
            child: DsTextField(
              label: 'Nama',
              validator: (value) =>
                  value == null || value.isEmpty ? 'Nama wajib diisi.' : null,
            ),
          ),
        ),
      ),
    );
    expect(key.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Amien');
    expect(key.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text('Nama wajib diisi.'), findsNothing);
  });
}
