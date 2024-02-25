if vim.g.vscode then
  -- vscode-neovim
  require 'config.vscode'
else
  -- neovide
  require 'config.neovide'

  -- neovim
  require 'config.options'
  require 'config.keymaps'
  require 'config.autocmds'
end

-- plugins
require 'config.lazy'
