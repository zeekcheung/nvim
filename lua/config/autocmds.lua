-- NOTE:
-- Setting Autocmds
-- See `:h autocmd` for more info

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom highlight group
local function customize_highlight()
  local overrided_colorschemes = { 'everforest', 'gruvbox-material', 'gruvbox' }
  local current_colorscheme = vim.g.colorscheme

  local get_hl = vim.api.nvim_get_hl_by_name
  local set_hl = vim.api.nvim_set_hl

  local ns_id = 0 -- Namespace id, set to 0 for global
  local normal_hl = get_hl('Normal', true) -- Normal highlight

  -- Override highlight groups for specfic colorschemes
  if vim.tbl_contains(overrided_colorschemes, current_colorscheme) then
    -- Split highlight
    set_hl(ns_id, 'WinSeparator', { bg = 'NONE', fg = '#33333f' })

    -- Neotree highlight
    set_hl(ns_id, 'NeoTreeNormal', { link = 'Normal' })
    set_hl(ns_id, 'NeoTreeEndOfBuffer', { link = 'Normal' })
  end

  -- Border highlight
  set_hl(ns_id, 'NormalFloat', { link = 'Normal' })
  set_hl(ns_id, 'LspInfoBorder', { link = 'Normal' })
  set_hl(ns_id, 'FloatBorder', { bg = normal_hl.background, fg = '#555555' })

  -- Bracket highlight
  set_hl(ns_id, 'RainbowDelimiterRed', { fg = '#e67e80' })
  set_hl(ns_id, 'RainbowDelimiterYellow', { fg = '#dbbc7f' })
  set_hl(ns_id, 'RainbowDelimiterBlue', { fg = '#7fbbb3' })
  set_hl(ns_id, 'RainbowDelimiterOrange', { fg = '#e69875' })
  set_hl(ns_id, 'RainbowDelimiterGreen', { fg = '#a7c080' })
  set_hl(ns_id, 'RainbowDelimiterViolet', { fg = '#d699b6' })
end

-- Auto setup colorscheme
autocmd({ 'VimEnter' }, {
  group = augroup('auto_setup_colorscheme', { clear = true }),
  callback = function()
    -- Setup background based on time
    -- local hour = tonumber(os.date '%H')
    -- if hour >= 9 and hour < 18 then
    --   vim.o.background = 'light'
    -- else
    --   vim.o.background = 'dark'
    -- end

    -- Setup colorscheme
    vim.cmd('colorscheme ' .. vim.g.colorscheme)

    customize_highlight()
  end,
})

-- Auto change float boarder highlight
autocmd({ 'ColorScheme' }, {
  group = augroup('change_float_highlight', { clear = true }),
  callback = function()
    customize_highlight()
  end,
})

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime', { clear = true }),
  command = 'checktime',
})

-- Resize splits if window got resized
autocmd({ 'VimResized' }, {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Wrap and check for spell in text filetypes
autocmd('FileType', {
  group = augroup('wrap_spell', { clear = true }),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Change indent size for different filetypes
autocmd('FileType', {
  group = augroup('change_options', { clear = true }),
  pattern = { 'c', 'h', 'cpp', 'nu' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Disable conceal of json
autocmd('FileType', {
  group = augroup('json_conceal', { clear = true }),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

-- Change json filetype to jsonc
autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('json_to_jsonc', { clear = true }),
  pattern = '*.json',
  callback = function()
    vim.bo.filetype = 'jsonc'
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Remove extra new lines at the end of formatted PowerShell files
autocmd('BufWritePost', {
  group = augroup('powershell_newline', { clear = true }),
  pattern = '*.ps1',
  callback = function()
    local winview = vim.fn.winsaveview()
    vim.cmd [[%s/\n\%$//ge]]
    vim.fn.winrestview(winview)
  end,
})

-- Jump to last edit position when opening files
autocmd('BufReadPost', {
  group = augroup('last_edit_position', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
autocmd('FileType', {
  group = augroup('close_with_q', { clear = true }),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'toggleterm',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})
