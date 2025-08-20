return { 
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- git
  },
  config = function()
    require("claude-code").setup()
  end
}
