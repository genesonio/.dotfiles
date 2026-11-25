return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  -- `master` is frozen but stable; `main` is a full rewrite without nvim-treesitter.configs
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    -- also provides the @function/@class queries mini.ai uses
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = { "go", "lua", "tsx", "javascript", "typescript", "vimdoc", "vim", "bash", "json", "prisma", "sql", "solidity", "yaml", "templ" },
    auto_install = false,
    sync_install = false,
    modules = {},
    ignore_install = {},

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<M-space>",
      },
    },
    textobjects = {
      -- af/if, ac/ic, aa/ia text objects are handled by mini.ai
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  },
}
