local overseer = require "overseer"

local function go_task(label, args, tag)
  return {
    name = "go: " .. label,
    desc = ("go %s"):format(table.concat(args, " ")),
    tags = tag and { tag } or nil,
    priority = 45,
    condition = {
      filetype = { "go" },
      root = { "go.mod" },
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
      local cmd = { "go" }
      vim.list_extend(cmd, args)
      for _, arg in ipairs(params.extra_args or {}) do
        table.insert(cmd, arg)
      end
      local run_cmd = { table.remove(cmd, 1) }
      return {
        cmd = run_cmd,
        args = cmd,
        cwd = params.cwd or vim.loop.cwd(),
        components = { "default", "unique" },
      }
    end,
  }
end

return {
  go_task("test", { "test", "./..." }, overseer.TAG.TEST),
  go_task("build", { "build", "./..." }, overseer.TAG.BUILD),
  go_task("run", { "run", "." }, overseer.TAG.RUN),
}
