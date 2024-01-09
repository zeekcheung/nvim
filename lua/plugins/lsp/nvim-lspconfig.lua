local Util = require 'util'
local LspUtil = require 'util.lsp'
local icons = Util.icons

-- Language servers
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    {
      'hrsh7th/cmp-nvim-lsp',
      cond = function()
        return Util.has 'nvim-cmp'
      end,
    },
    { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
  },
  opts = {
    -- Options for vim.diagnostic.config()
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        -- prefix = '●',
      },
      severity_sort = true,
      float = {
        header = false,
        border = 'rounded',
        focusable = true,
      },
    },
    inlay_hints = {
      enabled = true,
    },
    -- Automatically format on save
    autoformat = true,
    capabilities = {},
    -- Options for vim.lsp.buf.format
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    -- Servers listed below will be automatically installed through mason
    servers = {
      lua_ls = {
        Lua = {
          telemetry = { enable = false },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              [vim.fn.expand '$VIMRUNTIME/lua'] = true,
              [vim.fn.stdpath 'config' .. '/lua'] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    },
    -- Do any additional lsp server setup here
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },
  config = function(_, opts)
    -- Setup keymaps on LspAttach
    LspUtil.on_lsp_attach(function(client, buffer)
      LspUtil.setup_lsp_keymaps(client, buffer)
    end)

    -- Setup diagnostics icons in signcolumn
    local diagnostics_icons = icons.diagnostics
    for name, icon in pairs(diagnostics_icons) do
      name = 'DiagnosticSign' .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
    end

    -- Setup other diagnostics options
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local capabilities =
      vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities(), opts.capabilities or {})

    -- Setup language server with `opts.setup`
    local setup_server = function(server)
      local border = {
        { '╭', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '╮', 'FloatBorder' },
        { '│', 'FloatBorder' },
        { '╯', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '╰', 'FloatBorder' },
        { '│', 'FloatBorder' },
      }

      local server_opts = vim.tbl_deep_extend('force', {
        capabilities = vim.deepcopy(capabilities),
        -- Setup borders for hover and signature help
        -- handlers = {
        --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
        -- },
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup['*'] then
        if opts.setup['*'](server, server_opts) then
          return
        end
      end
      require('lspconfig')[server].setup(server_opts)
    end

    -- Get all the servers that are available thourgh mason-lspconfig
    local have_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
    local all_mason_lspconfig_servers = {}
    if have_mason_lspconfig then
      all_mason_lspconfig_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
    end

    local ensure_installed = {}
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mason_lspconfig_servers, server) then
          setup_server(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    -- Setup mason-lspconfig
    if have_mason_lspconfig then
      mason_lspconfig.setup { ensure_installed = ensure_installed }
      mason_lspconfig.setup_handlers { setup_server }
    end

    -- Avoid denols and tsserver run on the same time
    if LspUtil.get_lsp_config 'denols' and LspUtil.get_lsp_config 'tsserver' then
      local is_deno = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')
      LspUtil.disable_lsp('tsserver', is_deno)
      LspUtil.disable_lsp('denols', function(root_dir)
        return not is_deno(root_dir)
      end)
    end
  end,
}
