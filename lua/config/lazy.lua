local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable',
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require('lazy').setup {
  ui = { border = 'rounded' },
  spec = {
    { import = 'plugins' },
  },
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { 'habamax' } },
  checker = { enabled = false },
  change_detection = { enabled = false },
  performance = {
    cache = { enabled = true },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
