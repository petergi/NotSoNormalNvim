---@type LazySpec
return {
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          progress_icon = { pattern = "dots", period = 1 },
          done_icon = "",
        },
        lsp = {
          progress_ringbuf_size = 64,
        },
      },
      notification = {
        override_vim_notify = true,
        window = { winblend = 0 },
      },
    },
  },
}
