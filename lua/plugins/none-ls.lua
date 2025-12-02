-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- Customize None-ls sources
---@type LazySpec
-- ~/.config/nvim/lua/plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function(_, opts)
    local nls = require("null-ls")
    -- opts.sources = opts.sources or {}
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- add/remove to taste:
      nls.builtins.formatting.stylua,
      -- nls.builtins.formatting.prettierd,
      -- nls.builtins.diagnostics.eslint_d,
      -- nls.builtins.formatting.black,
      -- nls.builtins.formatting.shfmt,
    })
  end,
}
