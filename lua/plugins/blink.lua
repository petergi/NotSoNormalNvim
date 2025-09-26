local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function get_icon(ctx)
  local ok, mini_icons = pcall(require, "mini.icons")
  if not ok then return ctx.kind_icon, "BlinkCmpKind" .. ctx.kind, false end

  local source = ctx.item.source_name
  local label = ctx.item.label
  local color = ctx.item.documentation

  if source == "LSP" then
    if color and type(color) == "string" and color:match "^#%x%x%x%x%x%x$" then
      local hl = "hex-" .. color:sub(2)
      if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then vim.api.nvim_set_hl(0, hl, { fg = color }) end
      return "󱓻", hl, false
    else
      local icon, hl = mini_icons.get("lsp", ctx.kind)
      return icon, hl, false
    end
  elseif source == "Path" then
    if label:match "%.[^/]+$" then
      local icon, hl = mini_icons.get("file", label)
      return icon, hl, false
    else
      local icon, hl = mini_icons.get("directory", label)
      return icon, hl, false
    end
  elseif source == "codeium" then
    local icon, hl = mini_icons.get("lsp", "event")
    return icon, hl, false
  else
    return ctx.kind_icon, "BlinkCmpKind" .. ctx.kind, false
  end
end

return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "*",
  dependencies = {
    { "rafamadriz/friendly-snippets", lazy = true },
    "echasnovski/mini.icons",
  },
  opts = function(_, opts)
    -- Completely override the configuration to prevent issues with community pack providers
    local config = {
      snippets = {
        expand = function(snippet, _)
          local ok, utils = pcall(require, "utils")
          if ok and utils.expand then
            return utils.expand(snippet)
          else
            return vim.snippet.expand(snippet)
          end
        end,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { name = "LSP", module = "blink.cmp.sources.lsp" },
          path = { name = "Path", module = "blink.cmp.sources.path" },
          snippets = { name = "Snippets", module = "blink.cmp.sources.snippets" },
          buffer = { name = "Buffer", module = "blink.cmp.sources.buffer" },
          cmdline = { name = "Cmdline", module = "blink.cmp.sources.cmdline" },
        },
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then return { "buffer" } end
          if type == ":" or type == "@" then return { "cmdline" } end
          return {}
        end,
      },
      keymap = {
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-N>"] = {
          "snippet_forward",
        },
        ["<C-P>"] = {
          "snippet_backward",
        },
        ["<C-J>"] = { "select_next", "fallback" },
        ["<C-K>"] = { "select_prev", "fallback" },
        ["<C-U>"] = { "scroll_documentation_up", "fallback" },
        ["<C-D>"] = { "scroll_documentation_down", "fallback" },
        ["<C-E>"] = { "hide", "fallback" },
        ["<CR>"] = { "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.accept()
            elseif has_words_before() then
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_visible() then return cmp.select_prev() end
          end,
          "fallback",
        },
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      signature = {
        enabled = true,
        trigger = {
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,
        },
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        menu = {
          scrollbar = false,
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            components = {
              kind_icon = {
                ellipsis = true,
                text = function(ctx)
                  local icon, _, _ = get_icon(ctx)
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local _, hl, _ = get_icon(ctx)
                  return hl
                end,
              },
              kind = {
                ellipsis = true,
              },
            },
          },
        },
        -- NOTE: some LSPs may add auto brackets themselves anyway
        accept = {
          auto_brackets = { enabled = true },
        },
        -- Insert completion item on selection, don't select by default
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
            scrollbar = false,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        ghost_text = {
          enabled = false,
        },
      },
    }

    return config
  end,
  config = function(_, opts)
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      blink.setup(opts)
    else
      vim.notify("Failed to load blink.cmp: " .. tostring(blink), vim.log.levels.ERROR)
    end
  end,
  specs = {
    -- disable built in completion plugins
    { "hrsh7th/nvim-cmp", enabled = true },
    { "petertriho/cmp-git", enabled = true },
    { "L3MON4D3/LuaSnip", enabled = true },
    { "onsails/lspkind.nvim", enabled = true },
    -- Override Avante's Blink integration to prevent provider conflicts
    {
      "yetone/avante.nvim",
      optional = true,
      opts = function(_, opts)
        -- Disable Blink integration if it's causing issues
        if opts.specs then
          for i, spec in ipairs(opts.specs) do
            if spec[1] == "saghen/blink.cmp" or (type(spec) == "table" and spec.name == "saghen/blink.cmp") then
              opts.specs[i] = nil
            end
          end
        end
        return opts
      end,
    },
  },
}
