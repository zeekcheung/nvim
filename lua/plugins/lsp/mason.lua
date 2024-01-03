-- Installer for language servers, formatters, linters
return {
  'williamboman/mason.nvim',
  cmd = 'Mason',
  opts = {
    -- Tools listed below will be automatically installed
    ensure_installed = {
      'stylua',
      'shfmt',
    },
    ui = {
      icons = {
        package_pending = ' ',
        package_installed = '󰄳 ',
        package_uninstalled = '󰚌 ',
      },
    },
  },
  config = function(_, opts)
    -- Setup mason
    require('mason').setup(opts)

    local mason_registry = require 'mason-registry'

    -- Automatically install missing tools
    local ensure_installed = function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mason_registry.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

    if mason_registry.refresh then
      mason_registry.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
