# Repository Guidelines

## Project Structure & Module Organization
AstroNvim configuration centers around `init.lua`, which bootstraps lazy-loading and routes into modules under `lua/`. The `lua/plugins/` directory holds feature-scoped specs (`pack-*.lua` for language packs, `<feature>.lua` for tools), while `lua/utils/` carries helpers reused across specs. User tweaks that are not plugin definitions belong in `lua/polish.lua`, and shared snippets live in `snippets/`. Runtime or diagnostic artifacts should stay inside `reports/` to keep the root tidy.

## Build, Test, and Development Commands
- `nvim` — Launches Neovim with this profile; run after edits to ensure startup stays clean.
- `nvim --headless "+Lazy! sync" +qa` — Installs or updates plugins after modifying anything in `lua/plugins/`.
- `nvim --headless "+MasonInstall <pkg>" +qa` — Provision a language server defined in `lua/plugins/mason.lua`; replace `<pkg>` with one from `ensure_installed`.
- `bash installer.sh` — Rebuilds the managed toolchain and Treesitter parsers to match the curated list.

## Coding Style & Naming Conventions
Lua files use 2-space indentation and snake_case identifiers to mirror the existing modules. Run `stylua lua/ init.lua` to format and `selene .` to lint before pushing. Name new plugin specs descriptively (e.g., `pack-ruby.lua`, `git-tools.lua`) so functionality is discoverable at a glance.

## Testing Guidelines
Validate health headlessly with `nvim --headless "+checkhealth" +qa` and `nvim --headless "+Lazy! doctor" +qa` before submitting changes. Manually exercise new language packs or snippets in sample buffers, and capture any generated output under `reports/` when relevant. When wiring overseer or neotest tasks, document a minimal example invocation in code comments or the PR body.

## Commit & Pull Request Guidelines
Write concise, imperative commit subjects (e.g., "add amazonq integration"), and expand on context or regression risks in the body. Pull requests should summarize user-visible effects, list verification steps, and reference related issues or upstream plugin updates. Include screenshots or logs for UI-affecting changes involving `lualine`, `noice`, or visual plugins.

## Security & Configuration Tips
Never commit API tokens or machine-specific secrets; configure providers like Copilot via environment variables or local files ignored by Git. Keep personal tweaks inside `prefs.toml` or machine-scoped snippets so the shared configuration remains portable.
