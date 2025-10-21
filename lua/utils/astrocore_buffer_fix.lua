local M = {}

local applied = false

local list_tabpages = vim.api.nvim_list_tabpages
local current_tabpage = vim.api.nvim_get_current_tabpage
local buf_is_valid = vim.api.nvim_buf_is_valid
local exec_autocmds = vim.api.nvim_exec_autocmds

function M.apply()
  if applied then return true end

  local ok, astrocore = pcall(require, "astrocore")
  if not ok or type(astrocore.exec_buffer_autocmds) ~= "function" then return false end

  local extend_tbl = astrocore.extend_tbl

  astrocore.exec_buffer_autocmds = function(event, opts)
    opts = extend_tbl(opts, { modeline = false })
    local active_tabpage = current_tabpage()
    for _, tabpage in ipairs(list_tabpages()) do
      local bufs = vim.t[tabpage].bufs
      if bufs then
        local sanitized = {}
        for _, bufnr in ipairs(bufs) do
          if type(bufnr) == "number" and buf_is_valid(bufnr) then
            sanitized[#sanitized + 1] = bufnr
            local ft = vim.bo[bufnr].filetype
            if ft and ft ~= "" then
              opts.buffer = bufnr
              pcall(exec_autocmds, event, opts)
            end
          end
        end
        if #sanitized ~= #bufs then
          vim.t[tabpage].bufs = sanitized
          if tabpage == active_tabpage then vim.t.bufs = sanitized end
        end
      end
    end
  end

  applied = true
  return true
end

local function schedule_retry()
  vim.defer_fn(function()
    if applied then return end
    if not M.apply() then schedule_retry() end
  end, 20)
end

function M.ensure()
  if applied then return end
  if not M.apply() then schedule_retry() end
end

return M
