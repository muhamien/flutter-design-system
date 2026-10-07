---
name: flutter-component
description: "Generate or extend reusable Flutter UI components based on Material 3, including intent variants, interaction states, public exports, catalog examples, and focused tests. Use for controls rather than full business features."
---

# Flutter UI Component

Read the target project's architecture instructions, public exports, token/theme APIs, one similar component, and its catalog/test integration. In Nusantara UI use `packages/nusantara_ui/lib/src/components`, export from `lib/nusantara_ui.dart`, and demonstrate in `apps/catalog`.

## Define the contract

Choose a built-in Material widget and theme override when that satisfies the need. Add a `Ds` wrapper for a repeated intent/state contract, not merely to rename a widget. Before editing, identify required props, callbacks, variants, and applicable states (disabled/loading/error/focus/selection). Reuse established variant names. Keep internal implementation private and expose only the API the consumers need.

Read styles from `ColorScheme`, `TextTheme`, repository tokens, and registered extensions. Avoid free-form color overrides unless the product requirement demonstrates the need. Preserve semantics, focus/keyboard behavior, ripples, and hit targets supplied by Material. A loading action must prevent repeated callbacks while keeping its action recognizable; pair status icons with readable messages.

Make layouts work under bounded/narrow constraints, long labels, and increased text scale. Use directional padding/alignment where direction matters. Do not add a fixed text-containing height or disable text scaling to make a screenshot fit. For input wrappers expose the required validation/controller/autofill/action hooks; domain validation remains in the feature.

Components receive presentational data and callbacks. They do not access repositories, business providers, navigation destinations, or HTTP clients. Keep ownership explicit for controllers/focus nodes: dispose resources created inside the component; leave caller-owned resources to the caller.

## Ship the increment

Export the public component, add relevant catalog examples, and add behavioral tests for the new contract. Use a targeted accessibility/layout test when the component affects touch targets, semantics, or large text. Dispose a test `SemanticsHandle` inside `try/finally` before the widget test returns; generic `addTearDown` can run after framework verification.

Update `CHANGELOG.md` for public API/visual changes. Run formatting, analysis, relevant tests, and catalog build if integration changed. Use the pinned SDK and report missing checks accurately. Include a short consumer example and migration notes for breaking changes.
