-- Rename symbols
return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',
  keys = {
    { '<leader>rn', ':IncRename ', desc = 'Rename' },
  },
  config = true,
}
