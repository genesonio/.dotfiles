return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    warn_no_results = false,
    open_no_results = true,
  },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>", desc = "Show workspace errors" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Show workspace full diagnostics" },
    { "<leader>xn", "<cmd>Trouble next skip_groups=true jump=true<cr>", desc = "Next trouble item" },
    { "<leader>xp", "<cmd>Trouble prev skip_groups=true jump=true<cr>", desc = "Previous trouble item" },
  },
}
