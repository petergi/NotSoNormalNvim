# NotSoNormalNvim: My AstroNvim Configuration

**Important**: You need Neovim 0.10+

This is my personal Neovim distribution based on [AstroNvim](https://github.com/AstroNvim/AstroNvim). It's been heavily customized to fit my workflow and aesthetic preferences.

---

## Table of Contents

- [Screenshots](#screenshots)
- [Overview](#overview)
- [Installation](#installation)
- [Key Features](#key-features)
- [AI Integrations](#ai-integrations)
- [Language Support](#language-support)
- [Core Plugins](#core-plugins)
- [Keybindings](#keybindings)

## Screenshots

### Main Editor View
![Main Editor](assets/screenshots/main-editor.png)
*NotSoNormalNvim with AstroDark theme, Lualine statusline, and Bufferline*

### Claude Code Integration
![Claude Code](assets/screenshots/claude-code.png)
*Claude Code terminal split showing AI-assisted coding workflow*

### AI Tools Menu
![AI Tools](assets/screenshots/ai-menu.png)
*Which-key showing available AI integrations under `<Leader>A`*

### Completion with Blink.cmp
![Completion](assets/screenshots/completion.png)
*Blazing fast completions with Blink.cmp and LSP integration*

### Neo-tree File Explorer
![Neo-tree](assets/screenshots/neo-tree.png)
*Neo-tree file explorer with custom file creation templates*

### Overseer Task Runner
![Overseer](assets/screenshots/overseer.png)
*Overseer task list showing build and test tasks*

### Debugging with DAP
![DAP Debugging](assets/screenshots/dap-debug.png)
*nvim-dap debugger in action with breakpoints and variables*

### Trouble Diagnostics
![Trouble](assets/screenshots/trouble.png)
*Trouble showing project-wide diagnostics and errors*

## Overview

This configuration is built on top of AstroNvim, using Lazy.nvim for plugin management. It's designed for full-stack development with extensive language support and multiple AI coding assistants.

## Installation

### Prerequisites
- Neovim 0.10 or later
- Git
- A Nerd Font (for icons)
- `yazi` file manager (optional, will use neo-tree if not available)
- `trash` command (for neo-tree trash functionality)

### Clone
```sh
# Backup your existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this repository
git clone <your-fork-url> ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

## Key Features

### Plugin Management
- **Lazy.nvim**: Fast, modern plugin manager
- **AstroNvim**: Provides the base configuration framework
- **AstroCommunity**: Pre-configured language packs and recipes

### UI & Interface
- **Status Line**: Lualine (replaces default Heirline)
- **File Explorer**: Neo-tree with custom file creation templates
  - Go: Auto-adds package declaration
  - Rust: Interactive module attachment to lib.rs/main.rs/mod.rs
  - Proto: Auto-adds syntax and validation imports
- **Bufferline**: Enhanced buffer tab line
- **Dropbar**: Winbar with code context
- **Colorscheme**: AstroDark (default)

### Editing Enhancements
- **Completion**: Blink.cmp for blazing fast completions
- **Snippets**: LuaSnip with custom snippets
- **Auto-save**: Automatic file saving
- **Surround**: nvim-surround for manipulating surrounding pairs
- **Multi-cursor**: vim-visual-multi for multiple cursors
- **Flash**: Fast navigation and search
- **Auto-pairs**: Ultimate-autopair for intelligent bracket pairing
- **Refactoring**: The Primeagen's refactoring.nvim
- **Rainbow Delimiters**: Colorized matching brackets
- **True Zen**: Distraction-free editing

### Code Intelligence
- **LSP**: Full Language Server Protocol support via AstroLSP
- **Treesitter**: Advanced syntax highlighting and code understanding
- **Formatting**: Conform.nvim for code formatting
- **Linting**: nvim-lint for diagnostics
- **null-ls**: Additional formatting and diagnostics

### Development Tools
- **Debugger**: nvim-dap with full DAP support
- **Testing**: Neotest for running tests
- **Task Runner**: Overseer for build and test tasks
  - Custom templates for Node, Go, Python, Rust
- **Git**:
  - Gitsigns for inline git status
  - Diffview for viewing diffs
  - Git-blame inline blame
- **Session Management**: Resession for saving/restoring sessions

### Search & Navigation
- **Telescope**: Fuzzy finder (via AstroNvim)
- **FZF**: Alternative fuzzy finder integration
- **Grug-far**: Advanced search and replace
- **Trouble**: Better diagnostics list

## AI Integrations

This config includes multiple AI coding assistants:

### Claude Code
- **Plugin**: claude-code.nvim
- **Toggle**: `<C-,>` (normal/terminal mode)
- **Commands**:
  - `:ClaudeCode` - Open Claude Code terminal
  - `:ClaudeCodeContinue` - Resume most recent conversation
  - `:ClaudeCodeResume` - Show conversation picker
  - `:ClaudeCodeVerbose` - Enable verbose logging
- **Keybindings**:
  - `<C-,>` - Toggle Claude Code (normal/terminal mode)
  - `<leader>cl` - Continue recent conversation
  - `<leader>cr` - Resume with conversation picker
  - `<leader>cv` - Verbose mode
- **Location**: `lua/plugins/claude.lua`

### Avante
- **Plugin**: avante.nvim
- **Provider**: Copilot (with Claude for auto-suggestions)
- **Prefix**: `<Leader>P`
- **Key Features**:
  - AI-powered code generation
  - Multi-file context awareness
  - FZF file selector integration
- **Location**: `lua/plugins/avante.lua`

### GitHub Copilot
- **Plugin**: copilot.lua
- **Accept**: `<C-;>`
- **Next**: `<M-]>`
- **Previous**: `<M-[>`
- **Dismiss**: `<C-]>`
- **Panel**: `<Leader>Ap`
- **Location**: `lua/plugins/copilot.lua`

### Amazon Q
- **Plugin**: amazonq.nvim
- **Toggle**: `<leader>cq`
- **Visual Mode**: Select text and use `:AmazonQ`
- **Location**: `lua/plugins/amazonq.lua`

### Codex
- **Plugin**: codex.nvim
- **Custom status line integration**
- **Location**: `lua/plugins/codex.lua`

### AI Keybindings Summary
- **Claude Code**:
  - `<C-,>` - Toggle Claude Code
  - `<leader>cl` - Continue conversation
  - `<leader>cr` - Resume picker
  - `<leader>cv` - Verbose mode
- **Amazon Q**: `<leader>cq` - Toggle Amazon Q
- **Copilot**:
  - `<C-;>` - Accept suggestion
  - `<Leader>Ap` - Open panel
- **Avante**: `<Leader>P` prefix for AI commands

## Language Support

### Built-in Language Packs
Custom language configurations in `lua/plugins/pack-*.lua`:

- **Web Development**: Angular, TypeScript, JavaScript, HTML/CSS, Vue, Tailwind CSS
- **Backend**: Go, Python, Rust
- **Data**: JSON, YAML, TOML, XML, GraphQL
- **Systems**: Bash, Lua, Docker
- **Databases**: SQL, Prisma
- **Other**: Markdown, Thrift, Protocol Buffers

### AstroCommunity Packs
From `lua/community.lua`:
- C++ (`astrocommunity.pack.cpp`)
- C# (`astrocommunity.pack.cs`)
- Java (`astrocommunity.pack.java`)
- Swift (`astrocommunity.pack.swift`)

### LSP Features
- Mason for automatic LSP server installation
- Auto-completion with Blink.cmp
- Inline diagnostics
- Code actions
- Hover documentation
- Go-to-definition, references, implementations
- Formatting on save (via Conform)

## Core Plugins

### Essential Plugins
- **astrocore**: Core AstroNvim functionality and keybindings
- **astroui**: UI components and theming
- **astrolsp**: LSP configuration wrapper
- **mason.nvim**: LSP/DAP/Linter installer

### Notable Additions
- **snacks.nvim**: Collection of useful utilities
- **sleuth**: Auto-detect indentation
- **nvim-treesitter-context**: Show code context
- **nvim-regexplainer**: Explain regex patterns
- **todo-comments**: Highlight TODO/FIXME/etc
- **which-key**: Keybinding hints
- **live-server**: HTML live preview
- **molten**: Jupyter notebook integration
- **nvim-highlight-colors**: Color code highlighting
- **helpview**: Better help documentation

### UI Components
- **Lualine**: Status line with custom components:
  - Mode, branch, diagnostics
  - Root directory, file path
  - Codex status
  - DAP status
  - Lazy updates
  - Git diff
  - LSP progress (Fidget)
  - Overseer tasks
  - Snacks profiler
  - Time display

## Keybindings

### Leaders
- **Leader**: `<Space>`
- **Local Leader**: `,`

### Buffer Navigation
- `]b` - Next buffer
- `[b` - Previous buffer
- `<Leader>bd` - Close buffer (with picker)

### AI Tools
See [AI Integrations](#ai-integrations) section

### Overseer (Task Runner)
Prefix: `<Leader>m`
- `<Leader>mt` - Toggle Overseer
- `<Leader>mc` - Run command
- `<Leader>mr` - Run task
- `<Leader>mq` - Quick action
- `<Leader>ma` - Task action
- `<Leader>mi` - Overseer info
- `<Leader>mB` - Run build template
- `<Leader>mT` - Run test template

### Other
- See `:help astronvim` for default AstroNvim keybindings
- Press `<Space>` to see all available keybindings via which-key

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Bootstrap lazy.nvim
├── lua/
│   ├── lazy_setup.lua         # Lazy.nvim configuration
│   ├── polish.lua             # Final polish/tweaks
│   ├── community.lua          # AstroCommunity imports
│   ├── plugins/               # Plugin configurations
│   │   ├── astrocore.lua     # Core settings & keymaps
│   │   ├── astroui.lua       # UI settings
│   │   ├── astrolsp.lua      # LSP configuration
│   │   ├── pack-*.lua        # Language packs
│   │   └── ...               # Other plugin configs
│   ├── utils/                 # Utility functions
│   └── overseer/template/user/ # Custom Overseer templates
└── README.md                  # This file
```

## Notes

- This config disables Heirline in favor of Lualine
- Auto-save is enabled by default
- Diagnostics show as virtual text
- Git root is used as CWD when opening Claude Code
- Session management via Resession
- File refresh is enabled (100ms updatetime when Claude Code active)

## Maintenance

### Update Plugins
```vim
:Lazy update
```

### Check Health
```vim
:checkhealth
```

### Mason (Install LSP/DAP/Linters)
```vim
:Mason
```

## Credits

- Based on [AstroNvim](https://github.com/AstroNvim/AstroNvim)
- Inspired by NormalNvim (original base before heavy modifications)
