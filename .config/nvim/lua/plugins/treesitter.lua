local parsers = { "go", "lua", "tsx", "javascript", "typescript", "vimdoc", "vim", "bash", "json", "prisma", "sql", "solidity", "yaml", "templ" }

return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Neovim 0.12 provides node selection as visual-mode `an`/`in`
      vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start treesitter selection" })
      vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Grow treesitter selection" })
      vim.keymap.set("x", "<M-space>", "in", { remap = true, desc = "Shrink treesitter selection" })
    end,
  },

  {
    -- also provides the @function/@class queries mini.ai uses
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- runtime ftplugins (e.g. go, python) map ]] and [[ buffer-locally, which would shadow ours
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })

      local move = require("nvim-treesitter-textobjects.move")
      local maps = {
        ["]m"] = { move.goto_next_start, "@function.outer" },
        ["]]"] = { move.goto_next_start, "@class.outer" },
        ["]M"] = { move.goto_next_end, "@function.outer" },
        ["]["] = { move.goto_next_end, "@class.outer" },
        ["[m"] = { move.goto_previous_start, "@function.outer" },
        ["[["] = { move.goto_previous_start, "@class.outer" },
        ["[M"] = { move.goto_previous_end, "@function.outer" },
        ["[]"] = { move.goto_previous_end, "@class.outer" },
      }
      for key, m in pairs(maps) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          m[1](m[2], "textobjects")
        end)
      end
    end,
  },
}
