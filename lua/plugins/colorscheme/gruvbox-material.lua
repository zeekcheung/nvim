return {
  {
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
  },
  -- {
  --   'nvim-lualine/lualine.nvim',
  --   optional = true,
  --   config = function(_, opts)
  --     local gruvbox_material = require 'lualine.themes.gruvbox-material'
  --     local custom_gruvbox_material = gruvbox_material
  --
  --     custom_gruvbox_material.normal = gruvbox_material.insert
  --     custom_gruvbox_material.insert = gruvbox_material.visual
  --     custom_gruvbox_material.visual = gruvbox_material.replace
  --
  --     opts.options.theme = custom_gruvbox_material
  --     require('lualine').setup(opts)
  --   end,
  -- },
}
