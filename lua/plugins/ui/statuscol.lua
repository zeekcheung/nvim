return {
  'luukvbaal/statuscol.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    local builtin = require 'statuscol.builtin'

    local is_normal_buf = function(args)
      local buf = vim.api.nvim_win_get_buf(args.win)
      return vim.bo[buf].buftype == ''
    end

    require('statuscol').setup {
      relculright = true,
      segments = {
        {
          text = { builtin.foldfunc, ' ' }, -- fold column
          click = 'v:lua.ScFa',
          condition = {
            is_normal_buf,
            true,
          },
        },
        -- {
        --   sign = { -- diagnostic sign
        --     -- "Dap*", "Diagnostic*"
        --     name = { '.*' },
        --     -- "Dap*", "Diagnostic*"
        --     namespace = { 'Diagnostic*', '.*' },
        --     maxwidth = 1,
        --     colwidth = 2,
        --   },
        --   click = 'v:lua.ScSa',
        --   condition = { is_normal_buf, is_normal_buf },
        -- },
        {
          text = { builtin.lnumfunc, ' ' }, -- line number
          click = 'v:lua.ScLa',
        },
        {
          sign = { -- git sign
            name = { 'GitSigns*' },
            namespace = { 'gitsigns*' },
            maxwidth = 1,
            colwidth = 2,
          },
          click = 'v:lua.ScSa',
          condition = { is_normal_buf },
        },
      },
      ft_ignore = {
        'Trouble',
      },
      clickhandlers = {
        FoldOther = false,
      },
    }

    vim.api.nvim_create_autocmd('User', {
      pattern = 'ResessionLoadPost',
      callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == '' then
            vim.wo[win].stc = '%!v:lua.StatusCol()'
          end
        end
      end,
    })
  end,
}
