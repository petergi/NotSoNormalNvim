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
}
