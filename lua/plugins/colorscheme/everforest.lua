return {
  'sainnhe/everforest',
  enabled = false,
  priority = 1000,
  config = function()
    vim.o.background = 'dark'
    vim.g.everforest_background = 'hard'
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_show_eob = 0
    vim.g.everforest_diagnostic_text_highlight = 1
    vim.g.everforest_diagnostic_virtual_text = 'colored'
    vim.g.everforest_statusline_style = 'mix'

    vim.cmd [[colorscheme everforest]]
  end,
}
