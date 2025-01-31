---@diagnostic disable: undefined-doc-name
-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local function system(command)
  local file = assert(io.popen(command, "r"))
  local output = file:read("*all"):gsub("%s+", "")
  file:close()
  return output
end

---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- { "theHamsta/nvim-dap-virtual-text" },
      { "rcarriga/nvim-dap-ui" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "leoluz/nvim-dap-go",                module = "dap-go" },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      { "mxsdev/nvim-dap-vscode-js",         module = { "dap-vscode-js" } },
      {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
    },
    disable = false,
    config = function()
      local dap = require("dap")
      local dap_utils = require("dap.utils")
      local dap_vscode_js = require("dap-vscode-js")

      -- Set keymaps to control the debugger
      vim.keymap.set("n", "<F5>", require("dap").continue)
      vim.keymap.set("n", "<F10>", require("dap").step_over)
      vim.keymap.set("n", "<F11>", require("dap").step_into)
      vim.keymap.set("n", "<F12>", require("dap").step_out)
      vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint)
      vim.keymap.set(
        "n",
        "<leader>B",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        { desc = "Set breakpoint condition" }
      )

      -- JS, TS
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }
      -- CPP configurations
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }
      -- .Net configurations
      dap.adapters.coreclr = {
        type = "executable",
        command = "/Users/petergiannopoulos/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      -- Python configurations
      dap.adapters.python = {
        type = "executable",
        command = system("which python3"),
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      vim.api.nvim_set_keymap(
        "n",
        "<F8>",
        [[:lua require"dap".toggle_breakpoint()<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<F9>",
        [[:lua require"dap".continue()<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<F10>",
        [[:lua require"dap".step_over()<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<S-F10>",
        [[:lua require"dap".step_into()<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<F12>",
        [[:lua require"dap.ui.widgets".hover()<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<F5>",
        [[:lua require"osv".launch({port = 8086})<CR>]],
        { noremap = true }
      )

      dap.configurations.python = {
        {
          -- The first three options are required by nvim-dap
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Launch file (debugpy) 🔥🔥🔥",
          repl_lang = "python",
          logToFile = true,
          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

          program = "${file}", -- This configuration will launch the current file if used.
          pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return system("which python3")
            end
          end,
        },
      }

      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "0.0.0.0",
          port = 5005,
        },
      }

      ---@diagnostic disable-next-line: missing-fields
      dap_vscode_js.setup({
        debugger_path = os.getenv("HOME") .. "/Repos/vscode-js-debug",
        -- debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        },
        node_path = os.getenv("HOME")
            .. "/.nvm/versions/node/v18.20.4/bin/node ",
        debugger_cmd = { "js-debug-adapter" },   -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`
        log_file_path = "dap_vscode_js.log",     -- Path for file logging
        log_file_level = vim.log.levels.info,    -- Logging level for output to file. Set to false to disable file logging.
        log_console_level = vim.log.levels.info, -- Logging level for output to console. Set to false to disable console output.
      })

      for _, language in ipairs({
        "typescript",
        "javascript",
        "svelte",
        "astro",
        "vue",
        "javascriptreact",
        "typescriptreact",
      }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node)",
            cwd = vim.fn.getcwd(),
            args = { "${file}" },
            skipFiles = {
              "${workspaceFolder}/node_modules/**/*.js",
              "${workspaceFolder}/packages/**/node_modules/**/*.js",
              "${workspaceFolder}/packages/**/**/node_modules/**/*.js",
              "<node_internals>/**",
              "node_modules/**",
            },
            sourceMaps = true,
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            protocol = "inspector",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = dap_utils.pick_process,
            cwd = vim.fn.getcwd(),
            skipFiles = { "<node_internals>/**" },
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Mocha Tests",
            trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/mocha/bin/mocha.js",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
