-- Each entry is passed straight to vim.lsp.config(name, entry).
-- `settings` must be namespaced by the server's own section name (gopls, tailwindCSS, ...).
local servers = {
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  templ = {},
  sqlls = {},
  tailwindcss = {
    filetypes = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "templ" },
    settings = {
      tailwindCSS = {
        includeLanguages = { templ = "html" },
      },
    },
  },
  ts_ls = {},
  html = { filetypes = { "html", "templ" } },
  htmx = { filetypes = { "html", "templ" } },
  lua_ls = {},
  eslint = {},
  cssls = {},
  dockerls = {},
  -- schemas are added in config(), once SchemaStore is loaded
  jsonls = {},
  yamlls = {},
}

-- Formatters used by conform.nvim that mason should keep installed
-- (goimports comes from the system Go toolchain, templ from the templ LSP package)
local mason_tools = { "prettier", "gofumpt" }

local function ensure_mason_tools()
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, name in ipairs(mason_tools) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end)
end

local function on_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then return end

  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end
  local tb = require("telescope.builtin")

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", tb.lsp_definitions, "[G]oto [D]efinition")
  nmap("gr", tb.lsp_references, "[G]oto [R]eferences")
  nmap("<leader>D", tb.lsp_type_definitions, "Type [D]efinition")
  nmap("<leader>ws", tb.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")

  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")

  if client.name == "eslint" then
    nmap("<leader>ef", "<cmd>LspEslintFixAll<cr>", "[E]SLint [F]ix all")
  end

  if client.name == "ts_ls" then
    nmap("<leader>o", function()
      client:exec_cmd({
        title = "Organize imports",
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }, { bufnr = bufnr })
    end, "[O]rganize imports")
  end
end

return {
  {
    -- Lua LSP knowledge of the Neovim API (replaces neodev.nvim)
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {}, cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" } },
      "mason-org/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end
      vim.lsp.config("jsonls", {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
      })
      vim.lsp.config("yamlls", {
        settings = { yaml = { schemaStore = { enable = false, url = "" }, schemas = require("schemastore").yaml.schemas() } },
      })

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        -- we enable the servers ourselves below, so mason doesn't also enable
        -- every other server that happens to be installed
        automatic_enable = false,
      })
      vim.lsp.enable(vim.tbl_keys(servers))

      ensure_mason_tools()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = on_attach,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "enter",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = { auto_show = true },
      },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
    },
  },
}
