-- NOTE:
-- Setting options
-- See `:h vim.o` for more info

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.backup = false -- Don't keep a backup after overwriting a file
opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.completeopt = 'menu,menuone,noinsert'
opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = 'jcroqlnt' -- tcqj
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true -- Ignore case
opt.inccommand = 'nosplit' -- preview incremental substitute
-- opt.laststatus = 3 -- global statusline
opt.list = false -- Don't show some invisible characters (tabs...
opt.mouse = 'a' -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 0 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showmode = false -- Don't show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { 'en' }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = 'screen'
opt.splitright = true -- Put new windows right of current
opt.swapfile = false -- Don't use a swap file for this buffer
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = true -- Enable line wrap
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  -- fold = "⸱",
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

if vim.fn.has 'nvim-0.10' == 1 then
  opt.smoothscroll = true
end

-- Folding
opt.foldlevel = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'

local is_windows = require('util').is_win()

-- Change default shell to PowerShell on Windows
-- NOTE: Codeium cannot use PowerShell to authenticate
-- so we need to comment it out when we authenticate with Codeium
if is_windows then
  -- NOTE: We need to add PowerShell to the `PATH` for `vim.fn.executable 'pwsh'` to work
  opt.shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'Powershell'
  opt.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  opt.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
  opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  opt.shellquote = ''
  opt.shellxquote = ''
end

-- Disable some default providers
-- See `:h provider` for more info
for _, provider in ipairs { 'node', 'perl', 'python3', 'ruby' } do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local transparent_colorschemes = { 'gruvbox-material' }
vim.g.colorscheme = 'catppuccin'
-- vim.g.transparent_background = vim.tbl_contains(transparent_colorschemes, vim.g.colorscheme)
vim.g.transparent_background = vim.tbl_contains(transparent_colorschemes, vim.g.colorscheme)

vim.g.codeium_plugin_enabled = true -- Enable codeium.vim plugin
vim.g.codeium_enabled = not is_windows -- Disable codeium service

vim.g.noice_enabled = true -- Enable noice plugin

vim.g.border_style = 'rounded'
-- Top left, Top edge, Top right, Right edge, Bottom right, Bottom edge, Bottom left, Left edge
-- vim.g.border_style = { '', '', '', '', '', '', '', '' }
vim.g.cmp_custom_border = false and not vim.g.noice_enabled
vim.g.hover_custom_border = false and not vim.g.noice_enabled

vim.g.sticky_scroll = true -- Enable sticky_scroll
