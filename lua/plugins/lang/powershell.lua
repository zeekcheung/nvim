return {
  -- Language Server
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- make sure mason installs the server
      servers = {
        powershell_es = {
          settings = {},
        },
      },
    },
  },

  -- Syntax highlighting
  { 'PProvost/vim-ps1', ft = 'ps1' },
}
