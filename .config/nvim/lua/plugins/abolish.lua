return {
  "tpope/vim-abolish",
  init = function()
    -- disable abolish coercion mappings. I'm uisng coerce.nvim
    vim.g.abolish_no_mappings = true
  end
}
