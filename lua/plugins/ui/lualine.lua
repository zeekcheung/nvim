local LualineUtil = require 'util.lualine'

-- Statusline
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        component_separators = '',
        -- section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          LualineUtil.branch(),
        },
        lualine_c = {
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          { 'filename' },
          LualineUtil.diagnostics(),
          -- '%=',
        },
        lualine_x = {
          'fileformat',
          'encoding',
          LualineUtil.codeium(),
          LualineUtil.lspinfo(),
          -- LualineUtil.indent(),
        },
        lualine_y = {
          'progress',
        },
        lualine_z = {
          'location',
        },
      },
      extensions = { 'neo-tree', 'lazy' },
    }
  end,
}
