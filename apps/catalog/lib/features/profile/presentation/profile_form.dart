import 'package:flutter/material.dart';
import 'package:nusantara_ui/nusantara_ui.dart';
import 'profile_controller.dart';

// Caller owns controller lifecycle; this widget owns its input controller.
class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.controller});
  final ProfileController controller;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.controller.saveProfile(_name.text);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final state = widget.controller.state;
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsTextField(
              label: 'Nama lengkap',
              helperText:
                  'Masukkan "error" untuk mencoba kegagalan API simulasi.',
              controller: _name,
              enabled: !state.isSaving,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _save(),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama wajib diisi.'
                  : null,
            ),
            const SizedBox(height: DsSpace.md),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: DsButton(
                label: 'Simpan profil',
                icon: Icons.save_outlined,
                isLoading: state.isSaving,
                onPressed: _save,
              ),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: DsSpace.md),
              DsNotice(message: state.errorMessage!, tone: DsNoticeTone.error),
            ],
            if (state.savedName != null) ...[
              const SizedBox(height: DsSpace.md),
              DsNotice(
                message: 'Profil ${state.savedName} tersimpan (simulasi).',
                tone: DsNoticeTone.success,
              ),
            ],
          ],
        ),
      );
    },
  );
}
