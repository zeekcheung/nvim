-- NOTE: Some custom `lualine` components
local M = {}

local icons = require('util').icons

function M.branch()
  return {
    'branch',
    on_click = function()
      vim.cmd 'Telescope git_branches'
    end,
  }
end

function M.diagnostics()
  return {
    'diagnostics',
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
    -- always_visible = true,
    on_click = function()
      vim.cmd 'Telescope diagnostics bufnr=0'
    end,
  }
end

function M.indent()
  return {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, 'shiftwidth')
      return 'Tab:' .. shiftwidth
    end,
    padding = 1,
  }
end

function M.lspinfo()
  return {
    function()
      local names = {}
      for i, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
        table.insert(names, server.name)
      end
      if next(names) == nil then
        return 'Not Active Lsp'
      else
        return ' ' .. table.concat(names, ' ')
      end
    end,
    on_click = function()
      vim.cmd 'LspInfo'
    end,
  }
end

function M.codeium()
  return {
    'vim.fn["codeium#GetStatusString"]()',
    fmt = function(str)
      return icons.Codeium .. str
    end,
    cond = function()
      -- return package.loaded["codeium"]
      return package.loaded['codeium']
    end,
    on_click = function()
      if vim.fn['codeium#GetStatusString']() == 'OFF' then
        vim.cmd 'CodeiumEnable'
      else
        vim.cmd 'CodeiumDisable'
      end
    end,
  }
end

function M.season()
  return {
    function()
      local status = {
        spring = '🌴',
        summer = '🌊',
        autumn = '🎃',
        winter = '🏂',
      }
      local season = M.current_season()

      return status[season]
    end,
  }
end

return M
