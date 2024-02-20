-- NOTE:
-- Setting Autocmds
-- See `:h autocmd` for more info

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom highlight group
local function customize_highlight()
  local overrided_colorschemes = { 'everforest', 'gruvbox-material', 'gruvbox' }
  local current_colorscheme = vim.g.colorscheme

  -- Override highlight groups for specfic colorschemes
  if vim.tbl_contains(overrided_colorschemes, current_colorscheme) then
    -- Split highlight
    vim.cmd 'highlight! WinSeparator guibg=NONE guifg=#33333f'

    -- Neotree highlight
    vim.cmd 'highlight! link NeoTreeNormal Normal'
    vim.cmd 'highlight! link NeoTreeEndOfBuffer Normal'
  end

  -- Border highlight
  vim.cmd 'highlight! link NormalFloat Normal'
  vim.cmd 'highlight! link FloatBorder Normal'
  vim.cmd 'highlight! link LspInfoBorder Normal'

  -- Bracket highlight
  vim.cmd 'highlight RainbowDelimiterRed guifg=#e67e80'
  vim.cmd 'highlight RainbowDelimiterYellow guifg=#dbbc7f'
  vim.cmd 'highlight RainbowDelimiterBlue guifg=#7fbbb3'
  vim.cmd 'highlight RainbowDelimiterOrange guifg=#e69875'
  vim.cmd 'highlight RainbowDelimiterGreen guifg=#a7c080'
  vim.cmd 'highlight RainbowDelimiterViolet guifg=#d699b6'
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
