import '../domain/profile_repository.dart';

// Replace this adapter with an HTTP implementation in a real application.
class DemoProfileRepository implements ProfileRepository {
  @override
  Future<void> saveName(String name) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (name.toLowerCase() == 'error') {
      throw Exception('Simulated network failure');
    }
  }
}
