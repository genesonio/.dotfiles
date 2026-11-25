return {
  {
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
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next [H]unk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Previous [H]unk")
        map("n", "<leader>hs", gs.stage_hunk, "[H]unk [S]tage (toggle)")
        map("n", "<leader>hr", gs.reset_hunk, "[H]unk [R]eset")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[H]unk [S]tage lines")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[H]unk [R]eset lines")
        map("n", "<leader>hp", gs.preview_hunk_inline, "[H]unk [P]review")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "[H]unk [B]lame line")
        map({ "o", "x" }, "ih", gs.select_hunk, "inner hunk")
      end,
    },
  },
}
