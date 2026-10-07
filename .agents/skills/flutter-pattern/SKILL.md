---
name: flutter-pattern
description: "Generate reusable Flutter layout patterns and compositions from existing design-system components, with constraint-based responsiveness and catalog examples. Use for generic forms, sections, empty states, and page layouts."
---

# Flutter Responsive Pattern

Read the target architecture instructions, existing components, layout tokens, `DsPage` equivalent, public exports, and catalog. Nusantara UI places generic patterns at `packages/nusantara_ui/lib/src/patterns`; domain compositions remain under application features.

## Choose the boundary

A pattern composes controls and layouts around a reusable UI contract. A checkout summary with order calculations belongs to the checkout feature; a generic page section with header/body/actions may belong to the design system. Accept slots, presentational values, and callbacks rather than domain repositories or navigation logic.

Use existing components and Material semantics rather than rebuilding controls. Use local constraints (`LayoutBuilder`) to select layout behavior. Reuse layout tokens; introduce a new breakpoint only for a demonstrated layout transition. Do not infer layout from device labels alone.

Choose a scroll owner explicitly. Avoid nested unbounded vertical flex/scroll combinations. Support narrow widths, long content, and large text without forced text scaling or hiding essential actions. Maintain reading/focus order when changing column/row arrangements. Use directional alignment and padding where appropriate, and keep caller-versus-pattern responsibility for Scaffold/SafeArea clear.

## Integrate

Export a public generic pattern and demonstrate compact/expanded states in the catalog. Put domain-specific examples in the app without exporting them from the UI package. Add focused tests at constraints around an introduced breakpoint and for overflow at narrow width/large text. Check interactive behavior only when the pattern owns it.

Format/analyze using the pinned SDK and run relevant tests. Build the catalog when integration changes. Report the slot API, responsive rule, ownership boundaries, actual validation, and any migration requirement. Do not silently add a router, state management library, or data adapter to satisfy a layout request.
