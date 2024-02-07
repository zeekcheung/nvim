return {

  {
    'sainnhe/everforest',
    cond = vim.g.colorscheme == 'everforest',
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_dim_inactive_windows = 0
      vim.g.everforest_show_eob = 0
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = 'colored'
      vim.g.everforest_ui_contrast = 'high'
      -- vim.g.everforest_colors_override = { bg0 = '#1e1e2e' }

      if vim.g.transparent_background then
        vim.g.everforest_transparent_background = 2
      end
    end,
  },

  {
    'sainnhe/gruvbox-material',
    cond = vim.g.colorscheme == 'gruvbox-material',
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
      -- vim.g.gruvbox_material_statusline_style = 'mix'
      vim.g.gruvbox_material_ui_contrast = 'high'

      if vim.g.transparent_background then
        vim.g.gruvbox_material_transparent_background = 2
      end
    end,
  },

  {
    'catppuccin/nvim',
    cond = vim.g.colorscheme == 'catppuccin',
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
      highlight_overrides = {
        all = function(colors)
          return {
            CmpItemMenu = { bg = colors.base },
            Pmenu = { bg = colors.base, fg = '' },
            PmenuSel = { bg = colors.green, fg = colors.base },
          }
        end,
      },
    },
  },

  {
    'ellisonleao/gruvbox.nvim',
    cond = vim.g.colorscheme == 'gruvbox',
    priority = 1000,
    config = true,
    opts = {
      contrast = 'hard',
      overrides = {
        SignColumn = { link = 'Normal' },
        CursorLineNr = { bg = '' },
        GruvboxGreenSign = { bg = '' },
        GruvboxOrangeSign = { bg = '' },
        GruvboxPurpleSign = { bg = '' },
        GruvboxYellowSign = { bg = '' },
        GruvboxRedSign = { bg = '' },
        GruvboxBlueSign = { bg = '' },
        GruvboxAquaSign = { bg = '' },
      },
    },
  },
}
