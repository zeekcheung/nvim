-- Buffer remove
return {
  'echasnovski/mini.bufremove',
  keys = {
      -- stylua: ignore
      { "<leader>x", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
  },
}
