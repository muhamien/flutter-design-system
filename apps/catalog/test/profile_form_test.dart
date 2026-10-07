import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_ui/nusantara_ui.dart';
import 'package:nusantara_catalog/features/profile/domain/profile_repository.dart';
import 'package:nusantara_catalog/features/profile/presentation/profile_controller.dart';
import 'package:nusantara_catalog/features/profile/presentation/profile_form.dart';

class ImmediateRepository implements ProfileRepository {
  final names = <String>[];

  @override
  Future<void> saveName(String name) async {
    names.add(name);
    if (name == 'error') throw Exception('network');
  }
}

void main() {
  testWidgets('validates input and displays save outcome', (tester) async {
    final repository = ImmediateRepository();
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: DsTheme.build(),
        home: Scaffold(
          body: DsPage(child: ProfileForm(controller: controller)),
        ),
      ),
    );
    await tester.tap(find.text('Simpan profil'));
    await tester.pump();
    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    expect(repository.names, isEmpty);

    await tester.enterText(find.byType(TextFormField), 'Amien');
    await tester.tap(find.text('Simpan profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil Amien tersimpan (simulasi).'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'error');
    await tester.tap(find.text('Simpan profil'));
    await tester.pumpAndSettle();
    expect(
      find.text('Profil belum tersimpan. Silakan coba lagi.'),
      findsOneWidget,
    );
  });
}
