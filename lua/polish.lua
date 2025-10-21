-- Runs last in the setup process for user tweaks that don't fit elsewhere.
local ok, fix = pcall(require, "utils.astrocore_buffer_fix")
if ok then fix.ensure() end
