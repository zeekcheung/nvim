-- Key bindings popup
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      ['gs'] = { name = '+surround' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader>b'] = { name = '+buffer' },
      ['<leader>c'] = { name = '+code' },
      ['<leader>f'] = { name = '+find' },
      ['<leader>g'] = { name = '+git' },
      ['<leader>gh'] = { name = '+hunks' },
      ['<leader>q'] = { name = '+quit' },
      ['<leader>s'] = { name = '+search' },
      ['<leader>u'] = { name = '+ui' },
      ['<leader>w'] = { name = '+workspace' },
    },
  },
  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
