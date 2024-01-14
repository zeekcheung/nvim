vim.g.codeium_plugin_enabled = true
vim.g.codeium_enabled = false

return {
  'Exafunction/codeium.vim',
  enabled = vim.g.codeium_plugin_enabled,
  event = { 'VeryLazy' },
  -- stylua: ignore
  config = function (_, opts)
    vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end,
}
