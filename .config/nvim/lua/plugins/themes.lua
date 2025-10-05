return {
  "folke/tokyonight.nvim",
  lazy = false, -- optional, ensures it's loaded immediately
  config = function()
    require("tokyonight").setup({
      style = "night", -- or "storm", etc.
      transparent = true,
    })
    vim.cmd [[colorscheme tokyonight]]
  end,
}
