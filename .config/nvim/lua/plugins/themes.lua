return {
  "folke/tokyonight.nvim",
  lazy = false, -- optional, ensures it's loaded immediately
  config = function()
    require("tokyonight").setup({
      style = "night", -- or "storm", etc.
      transparent = true,
      styles = {
        -- floats = "transparent",
        -- sidebars = "transparent",
      },
      on_colors = function(colors)
        colors.fg_gutter = "#666666"
      end
    })
    vim.cmd [[colorscheme tokyonight]]
  end,
}
