-- Formatting. <leader>f and format-on-save both dispatch per filetype:
--   js/ts/jsx/tsx -> prettier
--   go            -> goimports (organize imports) + gofumpt
--   templ         -> templ fmt
--   anything else -> whatever LSP attached can format (lua_ls, html, ...)
local prettier = { "prettier" }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      go = { "goimports", "gofumpt" },
      templ = { "templ" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 1000,
    },
  },
}
