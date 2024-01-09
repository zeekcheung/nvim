return {
  {
    'sainnhe/gruvbox-material',
    enabled = true,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_dim_inactive_windows = 0
      vim.g.gruvbox_material_menu_selection_background = 'green'
      vim.g.gruvbox_material_show_eob = 0
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      -- vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.g.gruvbox_material_statusline_style = 'mix'
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    optional = true,
    config = function(_, opts)
      opts.options.theme = 'everforest'
      require('lualine').setup(opts)
    end,
  },
}
