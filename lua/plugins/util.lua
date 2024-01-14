vim.g.codeium_plugin_enabled = true
vim.g.codeium_enabled = true

return {

  -- Ai completion
  {
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
  },

  -- Session management
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- Projects management
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    opts = {
      manual_mode = false,
    },
    config = function(_, opts)
      require('project_nvim').setup(opts)
      require('util').on_load('telescope.nvim', function()
        require('telescope').load_extension 'projects'
      end)
    end,
    keys = {
      { '<leader>fp', '<Cmd>Telescope projects<CR>', desc = 'Projects' },
    },
  },

  -- Resize windows
  {
    'mrjones2014/smart-splits.nvim',
    event = 'BufReadPost',
    opts = {
      -- Ignored filetypes (only while resizing)
      ignored_filetypes = {
        'nofile',
        'quickfix',
        'qf',
        'prompt',
      },
      -- Ignored buffer types (only while resizing)
      ignored_buftypes = { 'nofile' },
    },
    keys = {
      { '<C-Up>', '<cmd>SmartResizeUp<cr>', 'Resize Up' },
      { '<C-Down>', '<cmd>SmartResizeDown<cr>', 'Resize Down' },
      { '<C-Left>', '<cmd>SmartResizeLeft<cr>', 'Resize Left' },
      { '<C-Right>', '<cmd>SmartResizeRight<cr>', 'Resize Right' },
    },
  },

  -- Rename symbols
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    keys = {
      { '<leader>rn', ':IncRename ', desc = 'Rename' },
    },
    config = true,
  },

  -- Smooth scroll
  {
    'karb94/neoscroll.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    enabled = not vim.g.neovide,
    config = function()
      require('neoscroll').setup {
        mappings = { '<C-u>', '<C-d>', '<C-f>', '<C-b>' },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      }
    end,
  },

  -- Code runner
  {
    'CRAG666/code_runner.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      filetype = {
        python = 'python3 -u',
        typescript = 'deno run',
        rust = {
          'cd $dir &&',
          'rustc $fileName &&',
          '$dir/$fileNameWithoutExt',
        },
      },
    },
    keys = {
      { '<f5>', '<cmd>RunCode<cr>', desc = 'Run code' },
      { '<leader>rc', '<cmd>RunCode<cr>', desc = 'Run code' },
      { '<leader>rp', '<cmd>RunProject<cr>', desc = 'Run project' },
    },
  },

  -- Open URL under the cursor
  {
    'chrishrb/gx.nvim',
    enabled = true,
    event = { 'BufNewFile', 'BufReadPre' },
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
      require('gx').setup {
        -- `sudo apt install wslu`
        open_browser_app = require('util').is_win() and 'powershell.exe' or 'xdg-open',
        -- open_browser_args = { "--background" },
        handlers = {
          plugin = true,
          github = true,
          brewfile = true,
          package_json = true,
          search = true,
        },
        handler_options = {
          search_engine = 'google',
          -- search_engine = "https://search.brave.com/search?q=",
        },
      }
    end,
  },

  -- Color highlight
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },

  -- Replace string
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        '<leader>sr',
        function()
          require('spectre').open()
        end,
        desc = 'Replace in files (Spectre)',
      },
    },
  },
}
