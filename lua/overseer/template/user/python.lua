local overseer = require "overseer"

local function python_task(label, command, tag)
  return {
    name = "python: " .. label,
    desc = table.concat(command, " "),
    tags = tag and { tag } or nil,
    priority = 40,
    condition = {
      filetype = { "python" },
      root = { "pyproject.toml", "setup.cfg", "setup.py", "tox.ini", "requirements.txt" },
    },
    params = {
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
    builder = function(params)
      local cmd = vim.deepcopy(command)
      local bin = table.remove(cmd, 1)
      for _, arg in ipairs(params.extra_args or {}) do
        table.insert(cmd, arg)
      end
      return {
        cmd = { bin },
        args = cmd,
        cwd = params.cwd or vim.loop.cwd(),
        components = { "default", "unique" },
      }
    end,
  }
end

return {
  python_task("pytest", { "pytest" }, overseer.TAG.TEST),
  python_task("ruff check", { "ruff", "check" }, overseer.TAG.BUILD),
}
