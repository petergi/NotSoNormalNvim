---@type LazySpec
return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  init = function()
    -- v4: keymaps controlled via vim.g flags, not setup({ keymaps })
    vim.g.nvim_surround_no_insert_mappings = true
  end,
  opts = {},
  keys = {
    { "gs", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround selection" },
  },
}
