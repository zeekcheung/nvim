return {

  {
    'sainnhe/everforest',
    enabled = true,
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      -- vim.g.everforest_dim_inactive_windows = 1
      vim.g.everforest_show_eob = 0
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = 'colored'

      if vim.g.transparent_background then
        vim.g.everforest_transparent_background = 2
      end
    end,
  },

  {
    'sainnhe/gruvbox-material',
    enabled = false,
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

      if vim.g.transparent_background then
        vim.g.gruvbox_material_transparent_background = 2
      end
    end,
  },

  {
    'catppuccin/nvim',
    enabled = false,
    priority = 1000,
    name = 'catppuccin',
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        navic = { enabled = true, custom_bg = 'lualine' },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
