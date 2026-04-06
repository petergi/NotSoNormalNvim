-- Minimal mouse test
vim.opt.mouse = "a"
vim.opt.termguicolors = true

-- Test mouse click mapping
vim.keymap.set("n", "<LeftMouse>", "<LeftMouse>", { desc = "Left mouse click" })
vim.keymap.set("n", "<RightMouse>", "<RightMouse>", { desc = "Right mouse click" })

print("Mouse support enabled: " .. vim.o.mouse)
