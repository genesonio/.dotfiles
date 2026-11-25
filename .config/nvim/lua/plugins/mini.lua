return {
  "echasnovski/mini.nvim",
  event = "VeryLazy",
  config = function()
    -- Around/Inside textobjects
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - daa  - [D]elete [A]round [A]rgument
    --  - vif  - [V]isually select [I]nside [F]unction (treesitter)
    --  - cic  - [C]hange [I]nside [C]lass (treesitter)
    local ai = require("mini.ai")
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      },
    })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()
  end,
}
