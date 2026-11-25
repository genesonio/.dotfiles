return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git", "Gclog", "Gllog", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "GBrowse" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>", desc = "[G]it [S]tatus" },
    {
      "<leader>gh",
      function()
        vim.cmd(vim.api.nvim_win_get_cursor(0)[1] .. ",Gclog")
      end,
      desc = "[G]it [H]istory of current line",
    },
    { "<leader>gH", "<cmd>Gclog --graph --oneline --all<cr>", desc = "[G]it [H]istory graph" },
    { "<leader>mc", "<cmd>Git mergetool<cr>", desc = "[M]erge [C]onflicts" },
    { "<leader>gu", "<cmd>Git fetch --all<cr>", desc = "Fetch all remotes", silent = true },
    { "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull branch", silent = true },
  },
}
