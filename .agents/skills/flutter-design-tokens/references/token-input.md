# Primitive token input contract

The helper accepts a small **project-specific JSON format**, not a DTCG/Figma Tokens interchange format. Convert other inputs deliberately; do not assume schema compatibility. [example.tokens.json](example.tokens.json) reproduces the existing Nusantara UI primitive values.

All five groups must be present and non-empty. Unknown groups, duplicate keys, reserved/invalid Dart identifiers, negative values, non-finite values, and booleans used as numbers are rejected.

| Group | Values | Generated API |
|---|---|---|
| `space` | Non-negative logical-pixel numbers | `DsSpace` |
| `radius` | Non-negative logical-pixel numbers | `DsRadius` |
| `layout` | Positive logical-pixel numbers | `DsLayout` |
| `motion` | Non-negative 64-bit integer milliseconds | `DsMotion` |
| `brand` | Opaque `#RRGGBB` seed colors | `DsBrand` enum |

Names use lowerCamelCase Dart identifiers. This helper does not generate typography, semantic colors, component styles, assets, or ThemeExtensions. It does not measure contrast or enforce a particular scale. Review tap targets and breakpoint relationships for the intended application.

From the skill directory:

```sh
python3 scripts/generate_tokens.py \
  --input references/example.tokens.json \
  --output /tmp/nusantara_tokens.dart
```

Without `--output`, Dart is printed to stdout. An existing target is refused by default. `--force` replaces the selected target after full input validation. No files are merged automatically, and input cannot be used as the output path.

When updating an existing design system, generate a temporary file, compare names/values against current tokens, and merge the requested changes. Do not treat this example JSON as a second source of truth for production tokens.
