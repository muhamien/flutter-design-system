import 'package:flutter/material.dart';
import 'package:nusantara_ui/nusantara_ui.dart';
import 'features/profile/data/demo_profile_repository.dart';
import 'features/profile/presentation/profile_controller.dart';
import 'features/profile/presentation/profile_form.dart';

void main() => runApp(const ShowcaseApp());

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  ThemeMode _mode = ThemeMode.system;
  DsBrand _brand = DsBrand.ocean;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Nusantara UI',
    theme: DsTheme.build(brand: _brand),
    darkTheme: DsTheme.build(brightness: Brightness.dark, brand: _brand),
    themeMode: _mode,
    themeAnimationDuration: DsMotion.feedback,
    home: ShowcasePage(
      mode: _mode,
      brand: _brand,
      onModeChanged: (value) => setState(() => _mode = value),
      onBrandChanged: (value) => setState(() => _brand = value),
    ),
  );
}

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({
    super.key,
    required this.mode,
    required this.brand,
    required this.onModeChanged,
    required this.onBrandChanged,
  });

  final ThemeMode mode;
  final DsBrand brand;
  final ValueChanged<ThemeMode> onModeChanged;
  final ValueChanged<DsBrand> onBrandChanged;

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  final _profile = ProfileController(DemoProfileRepository());

  @override
  void dispose() {
    _profile.dispose();
    super.dispose();
  }

  Widget _section(BuildContext context, String title, List<Widget> children) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(DsSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: DsSpace.md),
              ...children,
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nusantara UI')),
      body: SafeArea(
        child: DsPage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Satu sistem, banyak fitur.',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: DsSpace.sm),
              Text(
                'Material 3 dengan identitas brand dan komponen yang konsisten.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: DsSpace.lg),
              Wrap(
                spacing: DsSpace.lg,
                runSpacing: DsSpace.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  DropdownButton<ThemeMode>(
                    value: widget.mode,
                    onChanged: (value) {
                      if (value != null) widget.onModeChanged(value);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('Tema sistem'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Tema terang'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Tema gelap'),
                      ),
                    ],
                  ),
                  DropdownButton<DsBrand>(
                    value: widget.brand,
                    onChanged: (value) {
                      if (value != null) widget.onBrandChanged(value);
                    },
                    items: DsBrand.values
                        .map(
                          (brand) => DropdownMenuItem(
                            value: brand,
                            child: Text('Brand: ${brand.name}'),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: DsSpace.lg),
              _section(context, 'Komponen dan state', [
                Wrap(
                  spacing: DsSpace.sm,
                  runSpacing: DsSpace.sm,
                  children: [
                    DsButton(
                      label: 'Aksi utama',
                      icon: Icons.add,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aksi utama dipilih')),
                        );
                      },
                    ),
                    DsButton(
                      label: 'Sekunder',
                      variant: DsButtonVariant.secondary,
                      onPressed: () {},
                    ),
                    DsButton(
                      label: 'Tersier',
                      variant: DsButtonVariant.tertiary,
                      onPressed: () {},
                    ),
                    const DsButton(label: 'Nonaktif', onPressed: null),
                    const DsButton(
                      label: 'Memproses',
                      isLoading: true,
                      onPressed: null,
                    ),
                  ],
                ),
                const SizedBox(height: DsSpace.md),
                const DsNotice(
                  message: 'Informasi memakai pasangan warna semantik.',
                ),
                const SizedBox(height: DsSpace.sm),
                const DsNotice(
                  message: 'Data berhasil disimpan.',
                  tone: DsNoticeTone.success,
                ),
                const SizedBox(height: DsSpace.sm),
                const DsNotice(
                  message: 'Koneksi terputus. Silakan coba lagi.',
                  tone: DsNoticeTone.error,
                ),
              ]),
              const SizedBox(height: DsSpace.lg),
              _section(context, 'Contoh fitur: profil', [
                ProfileForm(controller: _profile),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
