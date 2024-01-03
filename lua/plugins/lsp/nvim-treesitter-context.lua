-- Show context of the current function
return {
  'nvim-treesitter/nvim-treesitter-context',
  enabled = false,
  event = { 'BufReadPre', 'BufNewFile' },
  opts = { mode = 'cursor', max_lines = 3 },
}
