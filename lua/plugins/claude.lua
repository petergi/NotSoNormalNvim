local function has_ui() return #vim.api.nvim_list_uis() > 0 end

return {
  "greggh/claude-code.nvim",
  enabled = has_ui,
  cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  opts = {
    keymaps = {
      toggle = {
        normal = false,
        terminal = false,
        variants = {
          continue = false,
          resume = false,
          verbose = false,
        },
      },
      window_navigation = true,
      scrolling = true,
    },
  },
  config = function(_, opts) require("claude-code").setup(opts) end,
}
