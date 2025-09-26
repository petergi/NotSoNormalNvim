-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.cs" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.swift" },

  { import = "astrocommunity.recipes.ai" },
  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },

  { import = "astrocommunity.completion.cmp-nvim-lua" },

  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },

  -- { import = "astrocommunity.docker.lazydocker" },

  -- import/override with your plugins folder
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  { import = "astrocommunity.editing-support.suda-vim" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.true-zen-nvim" },
  { import = "astrocommunity.editing-support.ultimate-autopair-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },

  { import = "astrocommunity.indent.snacks-indent-hlchunk" },

  { import = "astrocommunity.lsp.actions-preview-nvim" },
}
