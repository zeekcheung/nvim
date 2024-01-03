-- Formatters
return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'mason.nvim' },
  keys = {
    {
      '<leader>fm',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
    },
    format_on_save = {
      async = false,
      timeout_ms = 1000,
      lsp_fallback = true,
    },
  },
}
