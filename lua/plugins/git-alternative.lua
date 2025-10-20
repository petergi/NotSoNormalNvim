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
        -- If you have telescope installed, enable this
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
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPost",
    opts = {
      default_mappings = false,
      disable_diagnostics = true,
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      local map = vim.keymap.set
      map("n", "]x", "<cmd>GitConflictNextConflict<CR>", { desc = "Next conflict" })
      map("n", "[x", "<cmd>GitConflictPrevConflict<CR>", { desc = "Previous conflict" })
      map("n", "<Leader>gco", "<cmd>GitConflictChooseOurs<CR>", { desc = "Conflict choose ours" })
      map("n", "<Leader>gct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Conflict choose theirs" })
      map("n", "<Leader>gcb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Conflict choose both" })
      map("n", "<Leader>gc0", "<cmd>GitConflictChooseNone<CR>", { desc = "Conflict choose none" })
    end,
  },
}
