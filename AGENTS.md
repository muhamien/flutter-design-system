# Development instructions

## Git workflow

- Work on a dedicated working branch.
- Push the working branch and open a pull request for review.
- Do not push directly to `main`.
- Keep existing user changes intact and synchronize with the current remote base before editing.

## Design system

- Reusable UI belongs in `packages/nusantara_ui`; feature business logic belongs in the application.
- Read `docs/architecture.md` and existing public APIs before adding foundations or controls.
- Use Material themes and semantic roles; add wrappers for repeated behavior.
- Export new public UI and demonstrate it in `apps/catalog`.
- Use the SDK pinned in `.fvmrc` and report checks actually performed.

## AI skills

Repository skills live in `.agents/skills`. Read the relevant `SKILL.md` when a task matches its purpose. `flutter-design-system` routes cross-layer work; focused token/theme/component/pattern skills cover narrower requests. See `docs/ai-skills.md` for prompts and usage.

For changes to skill metadata or helpers, run `python3 tool/validate_skills.py` and `python3 -m unittest discover -s tool/tests -v` (validator dependency: `tool/requirements-skills.txt`).
