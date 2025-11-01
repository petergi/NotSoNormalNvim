local function has_ui() return #vim.api.nvim_list_uis() > 0 end

return {
  "greggh/claude-code.nvim",
  enabled = has_ui,
  cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
  keys = {
    { "<C-,>", mode = { "n", "t" } },
    { "<leader>cl", mode = "n", desc = "Toggle Claude Code" },
    { "<leader>cr", mode = "n", desc = "Toggle Claude Code - Resume" },
    { "<leader>cv", mode = "n", desc = "Toggle Claude Code - Verbose" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  opts = {
    keymaps = {
      toggle = {
        normal = "<C-,>",
        terminal = "<C-,>",
        variants = {
          continue = "<leader>cl",
          resume = "<leader>cr",
          verbose = "<leader>cv",
        },
      },
      window_navigation = true,
      scrolling = true,
    },
    -- Terminal window settings
    window = {
      split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
      position = "botright", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
      enter_insert = true, -- Whether to enter insert mode when opening Claude Code
      hide_numbers = true, -- Hide line numbers in the terminal window
      hide_signcolumn = true, -- Hide the sign column in the terminal window

      -- Floating window configuration (only applies when position = "float")
      float = {
        width = "80%", -- Width: number of columns or percentage string
        height = "80%", -- Height: number of rows or percentage string
        row = "center", -- Row position: number, "center", or percentage string
        col = "center", -- Column position: number, "center", or percentage string
        relative = "editor", -- Relative to: "editor" or "cursor"
        border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
      },
    },
    -- File refresh settings
    refresh = {
      enable = true, -- Enable file change detection
      updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
      timer_interval = 1000, -- How often to check for file changes (milliseconds)
      show_notifications = true, -- Show notification when files are reloaded
    },
    -- Git project settings
    git = {
      use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
    },
    -- Shell-specific settings
    shell = {
      separator = "&&", -- Command separator used in shell commands
      pushd_cmd = "pushd", -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
      popd_cmd = "popd", -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
    },
    -- Command settings
    command = "claude", -- Command used to launch Claude Code
    -- Command variants
    command_variants = {
      -- Conversation management
      continue = "--continue", -- Resume the most recent conversation
      resume = "--resume", -- Display an interactive conversation picker

      -- Output options
      verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
    },
  },
  config = function(_, opts) require("claude-code").setup(opts) end,
}
