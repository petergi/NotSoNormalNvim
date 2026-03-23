---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    init = function()
      -- PATCH: tree-sitter CLI >=0.25 removed --no-bindings, but the archived
      -- master branch of nvim-treesitter still passes it. Monkey-patch the
      -- generate args after the module loads. Safe to delete when AstroNvim
      -- upgrades to a compatible nvim-treesitter version.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
          if event.data ~= "nvim-treesitter" then return end
          local ok, install = pcall(require, "nvim-treesitter.install")
          if ok then
            local ts_version = require("nvim-treesitter.utils").ts_cli_version()
            if ts_version and vim.split(ts_version, " ")[1] > "0.20.2" then
              install.ts_generate_args = { "generate", "--abi", vim.treesitter.language_version }
            else
              install.ts_generate_args = { "generate" }
            end
          end
          return true -- removes this autocmd after firing
        end,
      })
    end,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "bash",
        "markdown",
        "markdown_inline",
        "lua",
        "vim",
      })

      opts.highlight = vim.tbl_deep_extend("force", { enable = true }, opts.highlight or {})

      opts.incremental_selection = vim.tbl_deep_extend("force", {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      }, opts.incremental_selection or {})

      opts.textobjects = vim.tbl_deep_extend("force", {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["]a"] = "@parameter.inner",
            ["]f"] = "@function.outer",
          },
          swap_previous = {
            ["[a"] = "@parameter.inner",
            ["[f"] = "@function.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      }, opts.textobjects or {})

      return opts
    end,
  },
}
