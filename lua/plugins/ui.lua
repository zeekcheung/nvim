local Util = require 'util'
local LualineUtil = require 'util.lualine'
local icons = Util.icons

return {

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = 'akinsho/bufferline.nvim',
    init = function()
      vim.opt.ruler = false
      vim.opt.showcmd = false
    end,
    opts = function()
      local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

      logo = string.rep('\n', 2) .. logo .. '\n'

      local opts = {
        theme = 'doom',
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
          tabline = true,
          winbar = true,
        },
        config = {
          header = vim.split(logo, '\n'),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files", desc = " Files", icon = " ", key = "f" },
            -- { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent", icon = " ", key = "r" },
            { action = "Telescope projects", desc = " Projects", icon = " ", key = "p" },
            { action = "lua require('util').find_configs()", desc = " Config", icon = " ", key = "c" },
            { action = "lua require('persistence').load()", desc = " Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms',
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 40 - #button.desc)
        button.key_format = '  %s'
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },

  -- Buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete buffers to the left' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete buffers to the right' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete other buffers' },
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
      { '<Tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    },
    opts = {
      options = {
        indicator = { icon = '' },
        separator_style = { '', '' },
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- diagnostics = 'nvim_lsp',
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local diagnostics_icons = icons.diagnostics
          local ret = (diag.error and diagnostics_icons.Error .. diag.error .. ' ' or '') .. (diag.warning and diagnostics_icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd('BufAdd', {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = 'auto',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
          component_separators = '',
          -- section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            LualineUtil.branch(),
          },
          lualine_c = {
            { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
            { 'filename' },
            LualineUtil.diagnostics(),
            -- '%=',
          },
          lualine_x = {
            LualineUtil.codeium(),
            LualineUtil.lspinfo(),
            LualineUtil.formatters(),
            LualineUtil.linters(),
            'encoding',
            LualineUtil.filetype(),
            'fileformat',
            -- LualineUtil.indent(),
          },
          lualine_y = {
            'progress',
          },
          lualine_z = {
            'location',
          },
        },
        extensions = { 'neo-tree', 'lazy' },
      }
    end,
  },

  -- Status column
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'lewis6991/gitsigns.nvim',
    },
    config = function()
      local builtin = require 'statuscol.builtin'

      local is_normal_buf = function(args)
        local buf = vim.api.nvim_win_get_buf(args.win)
        return vim.bo[buf].buftype == ''
      end

      require('statuscol').setup {
        relculright = true,
        segments = {
          -- fold column
          {
            text = { builtin.foldfunc, ' ' },
            click = 'v:lua.ScFa',
            condition = {
              is_normal_buf,
              true,
            },
          },
          -- diagnostic sign
          -- {
          --   sign = {
          --     -- "Dap*", "Diagnostic*"
          --     name = { '.*' },
          --     -- "Dap*", "Diagnostic*"
          --     namespace = { 'Diagnostic*', '.*' },
          --     maxwidth = 1,
          --     colwidth = 2,
          --   },
          --   click = 'v:lua.ScSa',
          --   condition = { is_normal_buf, is_normal_buf },
          -- },
          -- line number
          {
            text = { builtin.lnumfunc, ' ' },
            click = 'v:lua.ScLa',
          },
          -- git sign
          -- j
          {
            sign = {
              name = { 'GitSigns*' },
              namespace = { 'gitsigns*' },
              maxwidth = 1,
              colwidth = 2,
            },
            click = 'v:lua.ScSa',
            condition = { is_normal_buf },
          },
        },
        ft_ignore = {
          'Trouble',
        },
        clickhandlers = {
          FoldOther = false,
        },
      }

      vim.api.nvim_create_autocmd('User', {
        pattern = 'ResessionLoadPost',
        callback = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == '' then
              vim.wo[win].stc = '%!v:lua.StatusCol()'
            end
          end
        end,
      })
    end,
  },

  -- Better vim.ui
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },

  -- Better ui
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
        inc_rename = true,
      },
      views = {
        mini = {
          win_options = {
            -- transparent background
            winblend = 0,
          },
        },
      },
      -- cmdline = { view = 'cmdline' },
    },
  },

  {
    'rcarriga/nvim-notify',
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss { silent = true, pending = true }
        end,
        desc = 'Dismiss all Notifications',
      },
    },
    opts = {
      timeout = 2000,
      top_down = false,
      background_colour = '#000000',
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      if not Util.has 'noice.nvim' then
        Util.on_very_lazy(function()
          vim.notify = require 'notify'
        end)
      end
    end,
  },
}