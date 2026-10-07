# Nusantara UI

Material 3 design system starter for Flutter. Part of [flutter-design-system](https://github.com/muhamien/flutter-design-system).

```dart
import 'package:nusantara_ui/nusantara_ui.dart';

MaterialApp(
  theme: DsTheme.build(),
  darkTheme: DsTheme.build(brightness: Brightness.dark),
  themeMode: ThemeMode.system,
  home: myPage,
);
```

Use `DsButton`, `DsTextField`, `DsNotice`, and `DsPage` for shared UI contracts. Use themed Material widgets directly when no wrapper contract is needed. Import the public barrel, not `src/`.

This package contains no API clients, routing, domain validation, or business state. See the catalog app for integration.

Licensed under MIT. This starter is not published to pub.dev.
