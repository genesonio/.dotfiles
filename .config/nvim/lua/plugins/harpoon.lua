return {
  "theprimeagen/harpoon",
  config = function()
    local win_width = vim.api.nvim_win_get_width(0)
    require("harpoon").setup({
      menu = {
        width = math.floor(win_width - (win_width / 2)),
      },
    })
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", mark.add_file)
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

    vim.keymap.set("n", "<C-g>", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<C-b>", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<C-h>", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<C-n>", function() ui.nav_file(4) end)
  end
}
