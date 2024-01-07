-- NOTE:
-- Setting Keymaps
-- See `:h vim.keymap.set()` for more info

local UiUtil = require 'util.ui'

-- Make all keymaps silent by default
local keymap_set = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

local map = vim.keymap.set

-- Better escape
map('i', 'jj', '<esc>', { desc = 'Better Escape' })
map('i', 'jk', '<esc>', { desc = 'Better Escape' })
map('i', 'kk', '<esc>', { desc = 'Better Escape' })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffers
map('n', '<leader>bd', ':bd<cr>', { desc = 'Delete current buffer' })
map('n', '<Tab>', ':bn', { desc = 'Next buffer' })
map('n', '<S-Tab>', ':bp', { desc = 'Next buffer' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / clear hlsearch / diff update' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- Lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map({ 'n', 'v', 'x' }, '<leader>qw', '<cmd>exit<cr>', { desc = 'Quit current window' })
map({ 'n', 'v', 'x' }, 'q', '<cmd>exit<cr>', { desc = 'Quit current window' })

-- Save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Select all
map({ 'n', 'v', 'x', 'i' }, '<C-a>', 'ggVG', { desc = 'Select All' })

-- Split
map('n', '|', '<cmd>split<cr>', { desc = 'Horizontal Split' })
map('n', '\\', '<cmd>vsplit<cr>', { desc = 'Vertical Split' })

-- Toggle
map('n', '<leader>uc', UiUtil.toggle_conceal, { desc = 'Toggle conceal' })
map('n', '<leader>ub', UiUtil.toggle_background, { desc = 'Toggle background' })
map('n', '<leader>us', UiUtil.toggle_signcolumn, { desc = 'Toggle signcolumn' })
map('n', '<leader>ul', UiUtil.toggle_line_number, { desc = 'Change line number' })
map('n', '<leader>uu', UiUtil.toggle_foldcolumn, { desc = 'Toggle foldcolumn' })
map('n', '<leader>uH', UiUtil.toggle_ts_hightlight, { desc = 'Toggle Treesitter Highlight' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
