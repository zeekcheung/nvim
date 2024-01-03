-- Projects management
return {
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
}
