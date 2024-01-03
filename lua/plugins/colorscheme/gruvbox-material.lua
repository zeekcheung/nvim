return {
  'sainnhe/gruvbox-material',
  enabled = true,
  priority = 1000,
  config = function()
    vim.o.background = 'dark'
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_show_eob = 0
    vim.g.gruvbox_material_diagnostic_text_highlight = 1
    vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
    vim.g.gruvbox_material_statusline_style = 'mix'

    vim.cmd [[colorscheme gruvbox-material]]
  end,
}
