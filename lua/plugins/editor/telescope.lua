local Util = require 'util'

-- Fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  version = false, -- telescope did only one release, so use HEAD for now
  init = function()
    -- Avoid selected file opens in insert mode directly
    vim.api.nvim_create_autocmd('WinLeave', {
      callback = function()
        if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'i', false)
        end
      end,
    })
  end,
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      enabled = vim.fn.executable 'make' == 1,
      config = function()
        Util.on_load('telescope.nvim', function()
          require('telescope').load_extension 'fzf'
        end)
      end,
    },
  },
  opts = function()
    return {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        path_display = { 'truncate' },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = { prompt_position = 'top', preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          n = { ['q'] = require('telescope.actions').close },
        },
      },
    }
  end,
  keys = {
    -- find
    { '<leader>fa', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
    { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffer' },
      -- stylua: ignore
    { "<leader>fc", function() Util.find_configs() end, desc  = "Config" },
    {
      '<leader>fd',
      '<cmd>Telescope diagnostics bufnr=0<cr>',
      desc = 'Document diagnostics',
    },
    {
      '<leader>fD',
      '<cmd>Telescope diagnostics<cr>',
      desc = 'Workspace diagnostics',
    },
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Files' },
    { '<C-p>', '<leader>ff', desc = 'Find files', remap = true },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
    { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
    -- { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    -- { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { '<leader>fo', '<cmd>Telescope oldfiles<cr>', desc = 'Recent Files' },
    -- { '<C-p>', '<leader>fo', desc = 'Find files', remap = true },
    { '<leader>fr', '<cmd>Telescope registers<cr>', desc = 'Registers' },
    { '<leader>fw', '<cmd>Telescope live_grep<cr>', desc = 'Words' },
    -- git
    { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = 'branches' },
    { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'commits' },
    { '<leader>gf', '<cmd>Telescope git_files<CR>', desc = 'files' },
    { '<leader>gs', '<cmd>Telescope git_stash<CR>', desc = 'statsh' },
    { '<leader>gt', '<cmd>Telescope git_status<CR>', desc = 'status' },
  },
}
