---
name: flutter-theme
description: "Create or customize Flutter Material 3 themes, light/dark brand mappings, typography, component themes, and ThemeExtension roles. Use for application-wide visual configuration rather than feature-local styling."
---

# Flutter Material Theme

Read the target project's architecture instructions, tokens, `DsTheme` equivalent, custom extensions, public exports, and app theme registration. Nusantara UI uses `packages/nusantara_ui/lib/src/theme` and registers light/dark themes in `apps/catalog/lib/main.dart`. Check `.fvmrc` and installed APIs before adopting a newer Flutter API.

## Theme decisions

Use `ColorScheme.fromSeed` as the existing default, with brightness handled explicitly. Map Material roles through `ColorScheme` and typography through `TextTheme`. Preserve generated foreground/background pairs unless the requested brand contract needs measured overrides. If an exact primary is required, define its corresponding on-primary color for each supported brightness and verify contrast.

Customize built-in controls through their component themes. Do not set arbitrary colors throughout feature screens. Preserve Material disabled, hovered, pressed, focused, and error defaults unless a requested override needs a state resolver; make precedence explicit when states overlap.

Use a typed `ThemeExtension` only for roles not already covered by Material. Implement all fields in `copyWith` and `lerp`; register the extension in every supported brand/brightness. Preserve unrelated extensions when editing the theme builder. Avoid static mutable theme globals.

Keep platform font behavior unless a supplied font is requested. Bundled fonts need asset declarations and license information; do not introduce a network font dependency for an unspecified font. Do not override system text scaling to make layouts fit.

## Integration and verification

Register themes at the app boundary and let feature widgets consume semantic roles. Show a newly supported brand or theme option in the catalog where appropriate. Add focused tests for extension registration/interpolation and state or contrast behavior that changed. Check text on surfaces/buttons, field focus/error, status notices, and disabled/loading in light and dark modes.

Run the repository checks with the pinned SDK. Build the catalog if app/theme registration changed. Report the mapping decisions, changed files, example setup, validation, and any unsupported supplied brand value. Generated palettes are a starting point; certify accessibility only against checks actually performed.
