local overseer = require "overseer"

local function npm_script(script, tag)
  return {
    name = "npm: " .. script,
    desc = ("npm run %s"):format(script),
    tags = tag and { tag } or nil,
    priority = 50,
    params = {
      cmd = {
        type = "string",
        optional = true,
        default = "npm",
      },
      cwd = {
        type = "string",
        optional = true,
        default = vim.loop.cwd(),
      },
      extra_args = {
        type = "list",
        delimiter = " ",
        optional = true,
        default = {},
      },
    },
    condition = {
      filetype = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
      },
      root = { "package.json" },
    },
    builder = function(params)
      local cmd = params.cmd or "npm"
      local args = { "run", script }
      for _, arg in ipairs(params.extra_args or {}) do
        table.insert(args, arg)
      end
      return {
        cmd = { cmd },
        args = args,
        cwd = params.cwd or vim.loop.cwd(),
        components = { "default", "unique" },
      }
    end,
  }
end

return {
  npm_script("build", overseer.TAG.BUILD),
  npm_script("lint", overseer.TAG.BUILD),
  npm_script("test", overseer.TAG.TEST),
}
