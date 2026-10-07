---
name: flutter-design-system
description: "Generate a complete Flutter design system increment or coordinate changes spanning tokens, Material themes, reusable components, and catalog examples. Use for cross-layer UI foundations; use a focused skill for a single component or theme."
---

# Flutter Design System

Implement the requested design-system increment in the target Flutter repository.

## Locate the system

Use the user's target repository, not the skill installation directory, as the project root. Read its `AGENTS.md`, `docs/architecture.md`, `pubspec.yaml` files, and existing public exports. In Nusantara UI the package is `packages/nusantara_ui`, the demo is `apps/catalog`, and the baseline SDK is in `.fvmrc`. Discover equivalent locations in another project rather than creating a second design system.

Translate the brief into concrete roles, variants, interaction states, and responsive behavior. Infer ordinary choices from existing code and state the assumptions. Ask only when missing brand assets, target behavior, or public API requirements materially block implementation.

## Route only the needed work

Read the relevant sibling instruction file; do not load every skill by default:

- Primitive values or structured token imports: [flutter-design-tokens](../flutter-design-tokens/SKILL.md).
- Semantic roles, typography, brand/light/dark themes: [flutter-theme](../flutter-theme/SKILL.md).
- A reusable control and its state contract: [flutter-component](../flutter-component/SKILL.md).
- Reusable responsive compositions: [flutter-pattern](../flutter-pattern/SKILL.md).

For a cross-layer request, work from tokens to theme to components/patterns, then integrate the catalog. A component-only request does not justify changing all layers. If a sibling is unavailable, use the repository architecture and existing implementation as the contract.

## Integration contract

Keep business data, validation rules, network access, routing, and application state outside the UI package. The application chooses its state management. Prefer Material component themes for global appearance; wrappers should add a repeated API or behavior. Retain existing public names unless the requested change requires a migration.

For every new public component, export it and show its relevant variants/states in the catalog. For a token/theme-only change, verify existing consumers without inventing new controls. Add focused behavioral tests where the change affects interactions, layout, or theme transitions; document API/visual changes in `CHANGELOG.md`.

Use the pinned SDK. Run `./tool/check.sh` when available and build the catalog for integration changes. If tools are unavailable, report exactly what was checked and what remains unverified. Deliver changed files, example usage, validation, and any migration requirement. Generating UI does not itself authorize dependency installation outside the project, publishing, commits, pushes, or releases.
