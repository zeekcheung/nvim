-- Quickly jump
return {
  'folke/flash.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  vscode = true,
  opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
}
