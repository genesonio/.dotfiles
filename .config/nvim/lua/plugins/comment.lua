-- Neovim 0.10+ has built-in commenting (gc / gcc). This plugin just makes it
-- pick the right commentstring inside embedded languages, e.g. {/* */} in JSX.
return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = "VeryLazy",
  opts = {},
}
