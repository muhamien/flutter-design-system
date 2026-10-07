# Contributing

Issues and pull requests are welcome. Discuss substantial public API changes in an issue first. English and Indonesian contributions are both welcome.

## Development

Use Flutter 3.32.8 (also recorded in `.fvmrc`). FVM is optional.

```sh
./tool/check.sh
cd apps/catalog
flutter run -d chrome
```

## Adding a component

1. Explain the repeated product need; use a Material theme override if that is enough.
2. Define intent-based variants and state behavior before implementation.
3. Use ColorScheme/TextTheme or a documented ThemeExtension role.
4. Keep business state, API calls, and domain navigation outside the package.
5. Export the component from `nusantara_ui.dart` and add it to the catalog.
6. Add meaningful tests for behavior; check keyboard, semantics, large text, and light/dark mode.
7. Document API and visual changes in CHANGELOG.md.

## Pull requests

Describe the problem, resulting behavior, and validation. Include screenshots for visual changes. Keep changes focused. Do not commit credentials or generated build artifacts. API removals require a migration note and a versioning decision.

## License

By submitting a contribution, you agree that it can be distributed under the project's MIT license.
