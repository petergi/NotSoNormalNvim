# AstroNvim Configuration - AI Agent Guide

This is an **AstroNvim v5+ template** configuration built on the Lazy.nvim plugin manager. Understanding the layered
architecture is crucial for effective modifications.

## Core Architecture

### Three-Layer Plugin System

- **AstroCore** (`astrocore.lua`): Core settings, mappings, autocommands, vim options
- **AstroLSP** (`astrolsp.lua`): LSP configuration, server setup, formatting, handlers
- **AstroUI** (`astroui.lua`): UI elements, colorschemes, icons, status line integration

Each layer uses `opts` functions to extend base configurations rather than replacing them.

### Configuration Loading Order

```
init.lua → lazy_setup.lua → community.lua → plugins/*.lua → polish.lua
```

## Essential Patterns

### Plugin Activation Pattern

Most plugin files start with:

```lua
if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
```

**Remove this line** to enable the plugin configuration. This prevents accidental loading of incomplete configs.

### Lazy.nvim Spec Format

All plugin configurations must return a `LazySpec` table:

```lua
---@type LazySpec
return {
  "plugin/name",
  opts = { /* config */ },
  -- or function form for complex configs:
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, { /* your changes */ })
  end,
}
```

### Cross-Plugin Integration via `specs`

Use the `specs` key to modify other plugins when your plugin loads:

```lua
return {
  "my/plugin",
  specs = {
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        -- Modify astrolsp when this plugin loads
      end,
    },
  },
}
```

## File Organization

### Community Modules (`community.lua`)

Import pre-configured language packs from AstroCommunity:

```lua
{ import = "astrocommunity.pack.typescript" }
```

### Language Packs (`pack-*.lua`)

Follow the pattern in `pack-typescript.lua`:

- LSP configuration with custom `on_attach` functions
- Mason tool installation
- Treesitter parsers
- DAP (Debug Adapter Protocol) setup
- File type associations and formatters

### Utilities (`utils/`)

- `utils/init.lua`: Core helper functions for file operations, LSP clients, project detection
- `utils/lualine.lua`: Status line components
- `utils/ui.lua`: UI helper functions

## Development Workflows

### Adding New Language Support

1. Create `plugins/pack-{language}.lua`
2. Configure LSP in the `AstroLSP` opts function
3. Add Mason tools via `mason-tool-installer.nvim`
4. Set up Treesitter parsers
5. Configure DAP if debugging support needed

### Plugin Dependencies

- Use `optional = true` for plugins that might not be installed
- Check for plugin availability with `require("astrocore").plugin_opts "plugin-name"`
- Use `pcall(require, "plugin")` for conditional loading

### Key Mappings

Configure mappings in `astrocore.lua` under `opts.mappings` or use `require("astrocore").set_mappings()` in plugin
`on_attach` functions.

## Critical Conventions

### Extending vs. Replacing

Always extend existing configurations:

```lua
-- DO: Extend existing sources
opts.sources = require("astrocore").list_insert_unique(opts.sources, new_sources)

-- DON'T: Replace entirely
opts.sources = new_sources
```

### Conditional Formatting

Many language packs use project detection for formatters:

```lua
local has_prettier = function(bufnr)
  -- Check for prettier in package.json or config files
end
local conform_formatter = function(bufnr)
  return has_prettier(bufnr) and { "prettierd" } or {}
end
```

### LSP Configuration Patterns

- Use root pattern matching: `require("lspconfig.util").root_pattern(...)`
- Disable conflicting capabilities when needed (e.g., formatting when using external formatters)
- Configure server-specific settings in the `config` table

## Debugging & Troubleshooting

### Common Issues

- Plugin conflicts: Check `specs` interactions between plugins
- LSP not working: Verify Mason tool installation and `astrolsp` configuration
- Mappings not working: Ensure they're in the correct mode and check for conflicts

### Useful Commands

- `:Lazy` - Plugin manager interface
- `:Mason` - LSP/tool installer
- `:AstroInfo` - Configuration information
- `:checkhealth` - Neovim health checks

## File Templates

When creating new plugin files, use this template:

```lua
if true then return {} end -- Remove this line to activate

---@type LazySpec
return {
  "author/plugin-name",
  event = "VeryLazy", -- or appropriate lazy-loading event
  opts = {
    -- Plugin configuration
  },
}
```

This configuration emphasizes modularity, lazy loading, and non-destructive extension of base configurations.
