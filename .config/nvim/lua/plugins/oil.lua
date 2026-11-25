return {
  "stevearc/oil.nvim",
  -- not lazy so `nvim .` opens oil instead of netrw
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    columns = { "icon" },
    keymaps = {
      ["<C-h>"] = false, -- leave it for harpoon
    },
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    { "<leader>pv", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
}
