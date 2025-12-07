-- Configure snacks.nvim picker with frecency support
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      matcher = {
        frecency = true, -- enable frecency boosting for most commonly/recently used files
      },
    },
  },
}
