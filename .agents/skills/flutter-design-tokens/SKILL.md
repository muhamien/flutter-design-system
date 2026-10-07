---
name: flutter-design-tokens
description: "Generate or update Flutter primitive and semantic design tokens from a design brief, brand values, or the included structured token schema. Use for spacing, shape, layout, motion, and brand foundations."
---

# Flutter Design Tokens

Locate the target repository and read its architecture instructions, current tokens, theme mapping, and public exports. Nusantara UI primitives live at `packages/nusantara_ui/lib/src/tokens/ds_tokens.dart`. This skill works within the existing token model; do not introduce a parallel palette per feature.

## Map intent to tokens

- Primitive tokens hold raw spacing, radius, layout, duration, and seed values.
- Semantic color/text roles belong to `ColorScheme` / `TextTheme`; use a typed `ThemeExtension` for additional roles.
- Component-specific styling belongs to Material component themes or a justified component theme extension.

Reuse existing names and scales where possible. Prefer `space.md` / `radius.control` / `primary` over names tied to a hex value or feature. A new brand seed is not a promise that generated `primary` equals that seed. Keep paired foreground/background roles together when overriding generated colors.

For a prose brief, produce the minimal required Dart change directly. For JSON matching this skill's schema, read [the token input contract](references/token-input.md) and use the helper located relative to this `SKILL.md`:

```sh
python3 scripts/generate_tokens.py --input tokens.json --output generated_tokens.dart
```

The helper handles **primitive tokens only**, requires complete groups, and refuses to replace a file unless `--force` is provided. It does not merge files. Generate into a temporary file and review/diff before merging into an existing token file. Use `--force` only when replacement of that target is part of the user's request. Do not replace hand-maintained semantic extensions with generated primitives.

## Integrate

Preserve exported API names. Find consumers of changed values and adjust theme mappings only when required. If values vary by brand/density or animate, prefer a `ThemeExtension` with `copyWith` and `lerp` rather than additional global constants. Add a migration note for removals/renames.

Format and analyze the changed Dart files using the pinned SDK. Test theme or layout behavior affected by the token change; review both brightness modes and large text for sizing changes. Report token additions/changes, affected consumers, input assumptions, and actual validation. Do not claim contrast compliance from a seed value alone.
