import 'package:flutter/foundation.dart';
import '../domain/profile_repository.dart';

@immutable
class ProfileState {
  const ProfileState({
    this.isSaving = false,
    this.savedName,
    this.errorMessage,
  });

  final bool isSaving;
  final String? savedName;
  final String? errorMessage;
}

class ProfileController extends ChangeNotifier {
  ProfileController(this._repository);

  final ProfileRepository _repository;
  ProfileState _state = const ProfileState();
  bool _disposed = false;

  ProfileState get state => _state;

  Future<void> saveProfile(String name) async {
    if (_disposed || _state.isSaving) return;
    final normalized = name.trim();
    if (normalized.isEmpty) {
      _emit(const ProfileState(errorMessage: 'Nama wajib diisi.'));
      return;
    }
    _emit(const ProfileState(isSaving: true));
    try {
      await _repository.saveName(normalized);
      _emit(ProfileState(savedName: normalized));
    } catch (_) {
      // Raw transport exceptions should not appear as product copy.
      _emit(
        const ProfileState(
          errorMessage: 'Profil belum tersimpan. Silakan coba lagi.',
        ),
      );
    }
  }

  void _emit(ProfileState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
