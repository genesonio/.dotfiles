local function nav(n)
  return function()
    require("harpoon.ui").nav_file(n)
  end
end

return {
  "theprimeagen/harpoon",
  opts = function()
    local win_width = vim.api.nvim_win_get_width(0)
    return {
      menu = {
        width = math.floor(win_width / 2),
      },
    }
  end,
  keys = {
    { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon [A]dd file" },
    { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
    { "<C-g>", nav(1), desc = "Harpoon file 1" },
    { "<C-b>", nav(2), desc = "Harpoon file 2" },
    { "<C-h>", nav(3), desc = "Harpoon file 3" },
    { "<C-n>", nav(4), desc = "Harpoon file 4" },
  },
}
