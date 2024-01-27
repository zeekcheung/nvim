-- NOTE:
-- Setting Autocmds
-- See `:h autocmd` for more info

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom highlight group
local function customize_highlight()
  -- Border highlight
  vim.cmd [[highlight! link NormalFloat Normal]]
  vim.cmd [[highlight! link FloatBorder Normal]]

  -- Split highlight
  vim.cmd [[highlight! WinSeparator guibg=NONE guifg=#33333f]]
end

-- Auto setup colorscheme
autocmd({ 'VimEnter' }, {
  group = augroup('auto_setup_colorscheme', { clear = true }),
  callback = function()
    -- -- Setup background based on time
    -- local hour = tonumber(os.date '%H')
    -- if hour >= 9 and hour < 18 then
    --   vim.o.background = 'light'
    -- else
    --   vim.o.background = 'dark'
    -- end

    -- Setup colorscheme
    vim.cmd [[colorscheme everforest]]
    -- vim.cmd [[colorscheme catppuccin]]
    -- vim.cmd [[colorscheme gruvbox-material]]

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
