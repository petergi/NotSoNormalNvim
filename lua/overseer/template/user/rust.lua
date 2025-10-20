local overseer = require "overseer"

local function cargo_task(label, args, tag)
  return {
    name = "cargo: " .. label,
    desc = ("cargo %s"):format(table.concat(args, " ")),
    tags = tag and { tag } or nil,
    priority = 45,
    condition = {
      filetype = { "rust" },
      root = { "Cargo.toml" },
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
      local cmd = { "cargo" }
      vim.list_extend(cmd, args)
      for _, arg in ipairs(params.extra_args or {}) do
        table.insert(cmd, arg)
      end
      local bin = table.remove(cmd, 1)
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
  cargo_task("check", { "check" }, overseer.TAG.BUILD),
  cargo_task("clippy", { "clippy", "--all-targets", "--all-features" }, overseer.TAG.BUILD),
  cargo_task("test", { "test" }, overseer.TAG.TEST),
}
