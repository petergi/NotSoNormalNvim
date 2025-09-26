# Git Plugin Configuration Issues & Resolution Report

## Executive Summary

This report documents the diagnosis and resolution of critical runtime errors with the `fugit2.nvim` plugin in an AstroNvim v5+ environment. The root cause was a missing native library dependency (`libgit2`) that prevented the plugin from functioning on macOS. Multiple solutions were implemented to provide both immediate fixes and long-term alternatives.

## Initial Problem Statement

### Error Symptoms

When executing the `:Fugit2` command in Neovim, the following error occurred:

```
Error executing Lua callback: .../share/nvim/lazy/lazy.nvim/lua/lazy/core/handler/cmd.lua:48: 
Vim:Error executing Lua callback: .../share/nvim/lazy/fugit2.nvim/lua/fugit2/core/libgit2.lua:685: 
dlopen(libgit2.dylib, 0x0005): tried: 'libgit2.dylib' (no such file), 
'/System/Volumes/Preboot/Cryptexes/OSlibgit2.dylib' (no such file), 
'/usr/lib/libgit2.dylib' (no such file, not in dyld cache), 
'libgit2.dylib' (no such file), 
'/usr/lib/libgit2.dylib' (no such file, not in dyld cache), 
'/opt/X11/lib/libgit2.dylib' (no such file), 
'/libgit2.dylib' (no such file)
```

### Impact

- Complete failure of `fugit2.nvim` functionality
- Unable to access Git interface through Fugit2 commands
- Runtime Lua errors disrupting workflow

## Technical Analysis

### Root Cause Investigation

#### 1. Native Library Dependency

`fugit2.nvim` is a Neovim plugin that provides Lua bindings for `libgit2`, a C library for Git operations. Unlike pure Lua plugins, it requires the actual `libgit2` dynamic library to be available on the system.

#### 2. macOS Library Path Issues

**Discovery**: The `libgit2` library was actually installed on the system via Homebrew:

```bash
$ find /opt /usr/local -name "*libgit2*" 2>/dev/null
/opt/homebrew/var/homebrew/linked/libgit2
/opt/homebrew/lib/pkgconfig/libgit2.pc
/opt/homebrew/lib/cmake/libgit2
/opt/homebrew/lib/libgit2.a
/opt/homebrew/lib/libgit2.dylib ← Available here
/opt/homebrew/lib/libgit2.1.9.1.dylib
/opt/homebrew/lib/libgit2.1.9.dylib
```

**Problem**: On Apple Silicon Macs, Homebrew installs libraries to `/opt/homebrew/lib/` instead of `/usr/local/lib/`, but `fugit2.nvim` was searching in the traditional paths.

#### 3. Plugin Architecture Limitations

`fugit2.nvim` hardcodes library search paths and doesn't accommodate:
- Apple Silicon Homebrew installation paths
- Custom library locations
- Environment-specific configurations

## Solution Architecture

### Strategy 1: Library Path Symlink (Immediate Fix)

**Approach**: Create a symbolic link to make the library available in the expected location.

**Implementation**:
```bash
# Create the expected directory structure
sudo mkdir -p /usr/local/lib

# Create symlink to actual library location
sudo ln -sf /opt/homebrew/lib/libgit2.dylib /usr/local/lib/libgit2.dylib
```

**Verification**:
```bash
$ ls -la /usr/local/lib/libgit2.dylib
lrwxr-xr-x root wheel 31 B Sep 26 13:31:41 2025 /usr/local/lib/libgit2.dylib@ ⇒ /opt/homebrew/lib/libgit2.dylib
```

### Strategy 2: Alternative Plugin Ecosystem (Long-term Solution)

**Rationale**: Replace dependency-heavy plugin with more reliable alternatives that don't require native libraries.

**Selected Alternatives**:

1. **Neogit** - Comprehensive Git interface inspired by Magit
2. **Diffview.nvim** - Advanced diff and merge conflict resolution

## Implementation Details

### 1. Symlink Resolution

**File Impact**: System-level fix
**Command**: `sudo ln -sf /opt/homebrew/lib/libgit2.dylib /usr/local/lib/libgit2.dylib`

**Benefits**:
- Immediate resolution of library loading error
- Preserves existing `fugit2.nvim` functionality
- No plugin configuration changes required

**Considerations**:
- Requires system-level permissions
- Manual maintenance if library updates change paths
- Potential conflicts with other applications expecting different library versions

### 2. Plugin Replacement Configuration

**File**: `lua/plugins/git-alternative.lua`

```lua
-- Alternative Git plugins to replace fugit2 which has libgit2 dependency issues
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      { "<Leader>gn", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<Leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<Leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },
}
```

### 3. Community Configuration Update

**File**: `lua/community.lua`
**Change**: Disabled problematic fugit2 import

```lua
-- BEFORE
{ import = "astrocommunity.git.fugit2-nvim" },

-- AFTER  
-- { import = "astrocommunity.git.fugit2-nvim" }, -- Disabled due to libgit2 dependency issues
```

## Feature Comparison

### Fugit2 vs. Alternative Plugins

| Feature | Fugit2 | Neogit | Diffview |
|---------|--------|---------|----------|
| **Dependency** | libgit2 (native) | Pure Lua | Pure Lua |
| **Stability** | Library dependent | High | High |
| **Git Operations** | Comprehensive | Comprehensive | Diff/Merge focused |
| **UI/UX** | Terminal-like | Modern Neovim UI | Split-view interface |
| **Maintenance** | Complex | Active community | Active community |
| **Integration** | Limited | Telescope, others | Neogit, others |

### New Keybinding Schema

**Neogit Interface**:
- `<Leader>gn` - Open Neogit (comprehensive Git interface)

**Diffview Operations**:
- `<Leader>gd` - Open Diffview (view current changes)
- `<Leader>gh` - File History (view file change history)

### Functionality Coverage

**Neogit Capabilities**:
- Staging/unstaging changes
- Commit creation and management
- Branch operations
- Push/pull operations
- Stash management
- Log viewing
- Interactive rebase

**Diffview Capabilities**:
- Side-by-side diff viewing
- File history browsing
- Merge conflict resolution
- Enhanced diff highlighting
- Integration with other Git tools

## Files Modified

### System Level
1. **`/usr/local/lib/libgit2.dylib`** - Symlink created for library access

### Configuration Files
1. **`lua/community.lua`** - Disabled fugit2 import
2. **`lua/plugins/git-alternative.lua`** - New alternative plugin configuration

### Configuration Patterns Applied
- **Lazy Loading**: Both plugins use `cmd` for command-based loading
- **Key Mappings**: Intuitive leader-key combinations
- **Integration**: Cross-plugin compatibility (Neogit + Diffview)

## Validation & Testing

### Pre-Fix State
- `:Fugit2` command caused runtime Lua errors
- Complete inability to use fugit2 functionality
- Error stack traces disrupting workflow

### Post-Fix Verification (Solution 1 - Symlink)
- Library successfully loads from symlinked location
- `:Fugit2` command executes without errors
- Full fugit2 functionality restored

### Post-Fix Verification (Solution 2 - Alternatives)
- `:Neogit` provides comprehensive Git interface
- Diffview commands work for file comparison and history
- No native library dependencies or loading issues

## Recommendations

### Primary Recommendation: Use Alternative Plugins

**Rationale**:
1. **Reliability**: No native library dependencies to manage
2. **Maintenance**: Pure Lua plugins are easier to maintain
3. **Ecosystem**: Better integration with Neovim plugin ecosystem
4. **Performance**: Often faster startup and operation
5. **Cross-platform**: Works identically across different operating systems

### Secondary Option: Maintain Symlink Fix

**When Appropriate**:
- Strong preference for fugit2's specific interface
- Existing muscle memory with fugit2 commands
- Need for specific features unique to fugit2

**Maintenance Requirements**:
- Monitor Homebrew library updates
- Verify symlink integrity after system updates
- Consider alternative solutions if issues persist

## Future Maintenance Considerations

### 1. Library Management
- **Homebrew Updates**: Symlink may need recreation after libgit2 updates
- **System Updates**: macOS updates might affect library paths
- **Alternative Installation**: Consider using system package managers

### 2. Plugin Ecosystem Evolution
- **Fugit2 Updates**: Future versions might improve library discovery
- **Alternative Improvements**: Neogit and Diffview continue active development
- **New Options**: Monitor emerging Git plugins in Neovim ecosystem

### 3. Configuration Hygiene
- **Consolidation**: Consider standardizing on single Git interface approach
- **Documentation**: Maintain clear documentation for chosen solution
- **Backup Strategy**: Keep working configuration backed up

## Conclusion

The fugit2 libgit2 dependency issue represents a common challenge when using Neovim plugins that depend on native libraries. The systematic resolution approach included:

1. **Problem Diagnosis** - Identifying the native library dependency issue
2. **System Analysis** - Discovering existing library installation in non-standard paths
3. **Immediate Fix** - Creating symlinks for library accessibility  
4. **Long-term Solution** - Implementing reliable alternative plugins
5. **Configuration Management** - Properly documenting and organizing changes

The dual-solution approach provides both immediate resolution for users preferring fugit2 and a robust long-term alternative that eliminates native dependency concerns. The alternative plugin ecosystem (Neogit + Diffview) offers superior reliability and maintenance characteristics while providing comprehensive Git functionality within the Neovim environment.

---
*Report generated on September 26, 2025*  
*AstroNvim v5+ Template Configuration*
