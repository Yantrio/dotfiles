return {
  "AstroNvim/astrocore",
  --@type AstroCoreOpts
  opts = {
    autocmds = {
      restore_session = {
        {
          event = "VimEnter",
          desc = "Open file finder on startup",
          nested = true,
          callback = function()
            -- Check if no arguments or if the only argument is a directory
            local argc = vim.fn.argc(-1)
            local is_dir = false

            if argc == 1 then
              local arg = vim.fn.argv(0)
              is_dir = vim.fn.isdirectory(arg) == 1
            end

            if argc == 0 or is_dir then
              -- Open file finder instead of restoring session
              vim.defer_fn(function()
                -- AstroNvim v5 uses snacks.nvim for file picker
                require("snacks").picker.files()
              end, 10)
            end
          end,
        },
      },
    },
  },
}
