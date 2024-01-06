-- Smooth scroll
return {
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
}
