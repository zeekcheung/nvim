return {
  'sainnhe/everforest',
  enabled = true,
  priority = 1000,
  config = function()
    vim.g.everforest_background = 'hard'
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_transparent_background = 2
    vim.g.everforest_dim_inactive_windows = 1
    vim.g.everforest_show_eob = 0
    vim.g.everforest_diagnostic_text_highlight = 1
    vim.g.everforest_diagnostic_virtual_text = 'colored'
  end,
}
