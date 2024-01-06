-- Open URL under the cursor
return {
  'chrishrb/gx.nvim',
  enabled = true,
  event = { 'BufNewFile', 'BufReadPre' },
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    require('gx').setup {
      -- `sudo apt install wslu`
      open_browser_app = require('util').is_win() and 'powershell.exe' or 'xdg-open',
      -- open_browser_args = { "--background" },
      handlers = {
        plugin = true,
        github = true,
        brewfile = true,
        package_json = true,
        search = true,
      },
      handler_options = {
        search_engine = 'google',
        -- search_engine = "https://search.brave.com/search?q=",
      },
    }
  end,
}
