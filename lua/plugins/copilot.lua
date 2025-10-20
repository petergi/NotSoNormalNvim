local function has_ui() return #vim.api.nvim_list_uis() > 0 end

return {
  "zbirenbaum/copilot.lua",
  ---@type LazySpec
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  enabled = has_ui,
  opts = {
    panel = { enabled = false },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 150,
      keymap = {
        accept = "<C-;>",
        accept_line = false,
        accept_word = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            -- set the ai_accept function
            ai_accept = function()
              local ok, suggestion = pcall(require, "copilot.suggestion")
              if ok and suggestion.is_visible() then
                suggestion.accept()
                return true
              end
            end,
          },
        },
      },
    },
  },
}
