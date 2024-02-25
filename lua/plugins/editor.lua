local Util = require 'util'
local Ui = require 'util.ui'
local icons = Ui.icons

return {

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = {
      {
        '<C-e>',
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
        end,
        desc = 'Explorer',
      },
      { '<leader>e', '<C-e>', desc = 'Explorer', remap = true },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require 'neo-tree'
        end
      end

      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      enable_git_status = true,
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      source_selector = {
        winbar = false, -- toggle to show selector on winbar
        content_layout = 'center',
        tabs_layout = 'equal',
        show_separator_on_edge = true,
        sources = {
          { source = 'filesystem' },
          { source = 'buffers' },
          { source = 'git_status' },
          -- { source = "document_symbols" },
        },
      },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        modified = { symbol = icons.file.modified },
        git_status = {
          symbols = {
            added = icons.git.added,
            deleted = icons.git.removed,
            modified = icons.git.modified,
            renamed = icons.git.renamed,
            untracked = icons.git.untracked,
            ignored = icons.git.ignored,
            unstaged = icons.git.unstaged,
            staged = icons.git.staged,
            conflict = icons.git.conflict,
          },
        },
        diagnostics = {
          symbols = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warn = icons.diagnostics.Warn,
            error = icons.diagnostics.Error,
          },
        },
      },

      window = {
        mappings = {
          ['<Tab>'] = 'prev_source',
          ['<S-Tab>'] = 'next_source',
          ['s'] = 'none', -- disable default mappings
          ['<leftrelease>'] = 'open', -- open node with single left click
        },
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local toggleterm = require 'toggleterm'

      toggleterm.setup {
        highlights = {
          Normal = { link = 'Normal' },
          NormalNC = { link = 'NormalNC' },
          NormalFloat = { link = 'NormalFloat' },
          FloatBorder = { link = 'FloatBorder' },
          StatusLine = { link = 'StatusLine' },
          StatusLineNC = { link = 'StatusLineNC' },
          WinBar = { link = 'WinBar' },
          WinBarNC = { link = 'WinBarNC' },
        },
        size = 10,
        on_create = function()
          vim.opt.foldcolumn = '0'
          vim.opt.signcolumn = 'no'
        end,
        open_mapping = [[<F7>]],
        shading_factor = 2,
        direction = 'float',
        float_opts = { border = 'rounded' },
        autochdir = true,
      }

      local map = vim.keymap.set

      if vim.fn.executable 'lazygit' == 1 then
        local Terminal = require('toggleterm.terminal').Terminal

        local lazygit = Terminal:new {
          hidden = true,
          direction = 'float',
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd 'startinsert!'
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd 'startinsert!'
          end,
        }

        function _lazygit_toggle()
          lazygit.cmd = 'cd ' .. vim.fn.getcwd() .. ' && lazygit'
          lazygit:toggle()
        end

        map('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { desc = 'lazygit' })
      end

      map('t', '<esc>', [[<C-\><C-n>]])
      map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'ToggleTerm float' })
      map('n', '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', { desc = 'ToggleTerm horizontal split' })
      map('n', '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', { desc = 'ToggleTerm vertical split' })
    end,
  },

  -- Buffer remove
  {
    'echasnovski/mini.bufremove',
    keys = {
      -- stylua: ignore
      { "<leader>x", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- Fuzzy finder
  {
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
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
      -- { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      -- { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { '<leader>fo', '<cmd>Telescope oldfiles<cr>', desc = 'Recent Files' },
      { '<C-p>', '<leader>fo', desc = 'Recent Files', remap = true },
      { '<leader>fr', '<cmd>Telescope registers<cr>', desc = 'Registers' },
      { '<leader>fw', '<cmd>Telescope live_grep<cr>', desc = 'Words' },
      -- git
      { '<leader>gb', '<cmd>Telescope git_branches<cR>', desc = 'branches' },
      { '<leader>gc', '<cmd>Telescope git_commits<cR>', desc = 'commits' },
      { '<leader>gf', '<cmd>Telescope git_files<cR>', desc = 'files' },
      { '<leader>gs', '<cmd>Telescope git_stash<cR>', desc = 'statsh' },
      { '<leader>gt', '<cmd>Telescope git_status<cR>', desc = 'status' },
      -- Ui
      { '<leader>uc', '<cmd>Telescope colorscheme<cr>', desc = 'Colorscheme' },
    },
  },

  -- Quickly jump
  {
    'folke/flash.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    vscode = true,
    opts = {
      modes = {
        -- disable search integration
        search = { enabled = false },
        -- disable default keys
        char = { keys = {} },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- Git highlights
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

      -- stylua: ignore start
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- TODO, HACK, BUG, etc comment
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
  },

  -- Highlight word
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      providers = {
        'regex',
        'lsp',
        'treesitter',
      },
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
      end

      map(']]', 'next')
      map('[[', 'prev')

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', buffer)
          map('[[', 'prev', buffer)
        end,
      })
    end,
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
  },

  -- Key bindings popup
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { 'n', 'v' },
        ['g'] = { name = '+goto' },
        ['gs'] = { name = '+surround' },
        [']'] = { name = '+next' },
        ['['] = { name = '+prev' },
        ['<leader>b'] = { name = '+buffer' },
        ['<leader>c'] = { name = '+code' },
        ['<leader>f'] = { name = '+find' },
        ['<leader>g'] = { name = '+git' },
        ['<leader>gh'] = { name = '+hunks' },
        ['<leader>q'] = { name = '+quit' },
        ['<leader>r'] = { name = '+runner' },
        ['<leader>s'] = { name = '+search' },
        ['<leader>t'] = { name = '+terminal' },
        ['<leader>u'] = { name = '+ui' },
        ['<leader>w'] = { name = '+workspace' },
        ['<leader><tab>'] = { name = '+tabs' },
      },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
