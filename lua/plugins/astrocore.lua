-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local function run_if_cmd(cmd, args, message)
  return function()
    if vim.fn.exists(":" .. cmd) == 2 then
      if args and args ~= "" then
        vim.cmd(cmd .. " " .. args)
      else
        vim.cmd(cmd)
      end
    else
      vim.notify(message or ("Command :" .. cmd .. " is not available"), vim.log.levels.WARN)
    end
  end
end

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  init = function()
    local ok, fix = pcall(require, "utils.astrocore_buffer_fix")
    if not ok then return end
    fix.ensure()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function() fix.ensure() end,
      desc = "Ensure astrocore buffer exec patch is applied",
    })
  end,
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        ["<Leader>A"] = { desc = "AI" },
        ["<Leader>Ac"] = { run_if_cmd("ClaudeCode", "", "Claude Code is disabled"), desc = "Toggle Claude Code" },
        ["<Leader>Ap"] = { run_if_cmd("Copilot", "panel", "Copilot panel unavailable"), desc = "Copilot panel" },
        ["<Leader>Aq"] = { run_if_cmd("AmazonQ", "", "Amazon Q is disabled"), desc = "Amazon Q chat" },
        ["<Leader>AcC"] = {
          run_if_cmd("ClaudeCodeContinue", "", "Claude continue unavailable"),
          desc = "Claude continue",
        },
        ["<Leader>AcV"] = {
          run_if_cmd("ClaudeCodeVerbose", "", "Claude verbose unavailable"),
          desc = "Claude verbose",
        },
        ["<Leader>Aa"] = {
          function()
            local accept = vim.g.ai_accept
            if type(accept) == "function" and accept() then return end
            vim.notify("No AI suggestion available", vim.log.levels.INFO)
          end,
          desc = "Accept AI suggestion",
        },
      },
      v = {
        ["<Leader>Aq"] = { ":<C-u>AmazonQ<CR>", desc = "Amazon Q from selection" },
      },
    },
  },
}
