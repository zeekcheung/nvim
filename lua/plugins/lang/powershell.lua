return {
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
  { 'PProvost/vim-ps1', ft = 'ps1' },
}
