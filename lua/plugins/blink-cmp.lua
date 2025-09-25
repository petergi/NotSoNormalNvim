if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      {
        "SergioRibera/cmp-dotenv",
      },
    },
    opts = function(_, opts)
      -- Disabled due to Blink provider validation issues
      -- The dotenv provider needs proper module configuration
      return opts
    end,
  },
}
