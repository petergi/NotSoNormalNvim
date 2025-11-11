local function has_ui() return #vim.api.nvim_list_uis() > 0 end

return {
  {
    name = "amazonq",
    url = "https://github.com/awslabs/amazonq.nvim.git",
    enabled = has_ui,
    cmd = "AmazonQ",
    keys = {
      { "<leader>ca", "<cmd>AmazonQ<CR>", desc = "Toggle Amazon Q", mode = "n" },
    },
    config = function(_, opts)
      require("amazonq").setup(opts)
      pcall(vim.keymap.del, "n", "zq")
      pcall(vim.keymap.del, "x", "zq")
    end,
    opts = {
      ssoStartUrl = "https://view.awsapps.com/start", -- For Free Tier with AWS Builder ID

      -- See: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/q-language-ide-support.html
      -- `amazonq` is required for Q Chat feature.
      filetypes = {
        "amazonq",
        "bash",
        "java",
        "python",
        "typescript",
        "javascript",
        "csharp",
        "ruby",
        "kotlin",
        "sh",
        "sql",
        "c",
        "cpp",
        "go",
        "rust",
        "lua",
      },

      -- Enable/disable inline code suggestions
      inline_suggest = true,
      -- Configure the chat panel position and appearance
      on_chat_open = function()
        vim.cmd [[
      vertical topleft split
      set wrap breakindent nonumber norelativenumber nolist
    ]]
      end,
    },
  },
}
