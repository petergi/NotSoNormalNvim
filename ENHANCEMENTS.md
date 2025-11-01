# Neovim Enhancements Overview

This document captures the improvements applied on the `feature/neovim-enhancements` branch after branching from `baseline-pre-nvim-enhancements`.

## UI & Feedback
- Replaced Noice with `fidget.nvim` (`lua/plugins/fidget.lua`) to surface LSP progress with lighter footprint. The statusline now renders Fidget progress (`lua/plugins/lualine.lua:60`) while the old Noice spec was removed.
- FZF’s notification shortcut was redirected to `:messages` so the binding works without Noice (`lua/plugins/fzf.lua:87`).

## Performance & Startup
- Debug tooling now loads lazily: `nvim-dap`, UI, and virtual text attach only when their commands/modules are requested (`lua/plugins/dap.lua`), trimming initial startup.
- Overseer is command-driven instead of preloading on `AstroFile`, keeping background tasks idle (`lua/plugins/overseer.lua:1`).

## Treesitter Navigation
- Rebuilt the Treesitter spec to enable incremental selection, textobjects, and parameter swaps by default while ensuring essential parsers stay installed (`lua/plugins/treesitter.lua`).

## Task Automation
- Added language-aware Overseer templates for npm, Go, Python, and Cargo projects (`lua/overseer/template/user/*.lua`) and mapped quick shortcuts for build/test runners under `<leader>m` (`lua/plugins/overseer.lua:92`).

## Git Workflow
- Introduced `git-conflict.nvim` with focused keymaps for stepping through and resolving merges (`lua/plugins/git-alternative.lua:34`) alongside existing Neogit and Diffview tooling.

## AI Integrations
- Standardized Copilot, Amazon Q, and Claude Code:
  - Conditional loading when a UI is available (`lua/plugins/copilot.lua`, `amazonq.lua`, `claude.lua`).
  - Shared `<leader>A…` key family for launching providers or accepting suggestions (`lua/plugins/astrocore.lua:96`), plus a guarded handler that falls back gracefully in headless sessions.
  - Amazon Q’s hard-coded `zq` mappings are removed during setup to avoid key conflicts (`lua/plugins/amazonq.lua:7`).

## Follow-up
- Run `:Lazy sync` (or `nvim --headless "+Lazy! sync" +qa`) to install new plugins such as Fidget and Git Conflict.
- Execute `:CheckHealth` outside the sandbox once installations complete; sandbox limitations prevented automated health checks in this environment.
