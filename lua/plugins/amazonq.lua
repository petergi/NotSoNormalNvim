-- if true then return • end - - WARN: REMOVE THIS LINE TO ACTIVATE THE PLUGIN
--@type LazySpec
return {
  {
    name = "amazonq",
    url = "https://github.com/awslabs/amazonq.nvim.git",
    opts = {
      ssoStartUrl = "https://view.awsapps.com/start", -- For Free Tier with AWS Builder ID
      -- Filetypes where the Q will be activated
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
