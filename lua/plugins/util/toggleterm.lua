-- Terminal
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    local toggleterm = require 'toggleterm'

    toggleterm.setup {
      highlights = {
        Normal = { link = 'Normal' },
        NormalNC = { link = 'NormalNC' },
        NormalFloat = { link = 'NormalFloat' },
        FloatBorder = { link = 'FloatBorder' },
        StatusLine = { link = 'StatusLine' },
        StatusLineNC = { link = 'StatusLineNC' },
        WinBar = { link = 'WinBar' },
        WinBarNC = { link = 'WinBarNC' },
      },
      size = 10,
      on_create = function()
        vim.opt.foldcolumn = '0'
        vim.opt.signcolumn = 'no'
      end,
      open_mapping = [[<F7>]],
      shading_factor = 2,
      direction = 'float',
      float_opts = { border = 'rounded' },
      autochdir = true,
    }

    local map = vim.keymap.set

    if vim.fn.executable 'lazygit' == 1 then
      local Terminal = require('toggleterm.terminal').Terminal

      local lazygit = Terminal:new {
        cmd = 'cd ' .. vim.fn.getcwd() .. ' && lazygit',
        hidden = true,
        direction = 'float',
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd 'startinsert!'
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd 'startinsert!'
        end,
      }

      function _lazygit_toggle()
        lazygit.dir = vim.fn.getcwd()
        lazygit:toggle()
      end

      map('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { desc = 'lazygit' })
    end

    map('t', '<esc>', [[<C-\><C-n>]])
    map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'ToggleTerm float' })
    map('n', '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', { desc = 'ToggleTerm horizontal split' })
    map('n', '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', { desc = 'ToggleTerm vertical split' })
  end,
}
