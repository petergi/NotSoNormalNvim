-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Disabled due to Blink configuration conflicts
-- This plugin modifies Blink keymaps which conflicts with our main Blink configuration
return {
  ---@type LazySpec
  "Saghen/blink.cmp",
  optional = true,
  opts = function(_, opts)
    -- Keymap configuration moved to main blink.lua to prevent conflicts
    return opts
  end,
}
