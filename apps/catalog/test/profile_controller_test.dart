import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_catalog/features/profile/domain/profile_repository.dart';
import 'package:nusantara_catalog/features/profile/presentation/profile_controller.dart';

class ControlledRepository implements ProfileRepository {
  var completion = Completer<void>();
  final calls = <String>[];

  @override
  Future<void> saveName(String name) {
    calls.add(name);
    return completion.future;
  }
}

void main() {
  test('trims input, blocks duplicate requests, then emits success', () async {
    final repository = ControlledRepository();
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);
    final pending = controller.saveProfile(' Amien ');
    expect(controller.state.isSaving, isTrue);
    await controller.saveProfile('Other');
    expect(repository.calls, ['Amien']);
    repository.completion.complete();
    await pending;
    expect(controller.state.isSaving, isFalse);
    expect(controller.state.savedName, 'Amien');
  });

  test('reports failure and allows a retry', () async {
    final repository = ControlledRepository();
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);
    final pending = controller.saveProfile('Amien');
    repository.completion.completeError(Exception('transport failure'));
    await pending;
    expect(controller.state.isSaving, isFalse);
    expect(controller.state.errorMessage, isNotNull);
    repository.completion = Completer<void>();
    final retry = controller.saveProfile('Amien');
    repository.completion.complete();
    await retry;
    expect(repository.calls.length, 2);
    expect(controller.state.savedName, 'Amien');
    expect(controller.state.errorMessage, isNull);
  });

  test('rejects empty input without calling repository', () async {
    final repository = ControlledRepository();
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);
    await controller.saveProfile('   ');
    expect(repository.calls, isEmpty);
    expect(controller.state.errorMessage, 'Nama wajib diisi.');
  });

  test('ignores async completion after disposal', () async {
    final repository = ControlledRepository();
    final controller = ProfileController(repository);
    var notifications = 0;
    controller.addListener(() => notifications++);
    final pending = controller.saveProfile('Amien');
    controller.dispose();
    repository.completion.complete();
    await pending;
    expect(notifications, 1);
  });
}
