-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- local defold_stubs_path = "/home/genesonio/.config/nvim/after/externals/defold-stubs"

local templ_format = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local cmd = "templ fmt " .. vim.fn.shellescape(filename)

  vim.fn.jobstart(cmd, {
    on_exit = function()
      -- Reload buffer
      if vim.api.nvim_get_current_buf() == bufnr then
        vim.cmd("e!")
      end
    end,
  })
end

local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  gopls = {
    analyses = {
      unusedparams = true,
    },
    staticcheck = true,
    gofumpt = true,
  },
  templ = {},
  sqlls = {},
  tailwindcss = {
    filetypes = {
      'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'react'
    },
    settings = {
      tailwindcss = {
        includeLanguages = { templ = 'html', },
      },
    },
  },
  ts_ls = {},
  html = { filetypes = { 'html', 'templ' } },
  htmx = { filetypes = { 'htmx', 'templ', 'html' } },
  lua_ls = {
    filetypes = { 'lua', 'script' },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Server-specific configurations
local server_specific_configs = {
  ts_ls = function(bufnr)
    vim.keymap.set("n", "<leader>o", function()
      local clients = vim.lsp.getClients({ bufnr = 0 })
      for _, client in ipairs(clients) do
        client:execute_command({
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = ""
        })
      end
    end, { buffer = bufnr, desc = "Organize imports" })

    vim.keymap.set("n", "<leader>ef", function()
      vim.cmd.EslintFixAll()
    end, { buffer = bufnr, desc = "ESLint fix all" })
  end,

  gopls = function(bufnr)
    vim.keymap.set("n", "<leader>f", function()
      -- Save the file first
      if vim.bo.modified then
        vim.cmd("write")
      end

      -- Request organize imports and apply them
      local params = vim.lsp.util.make_range_params(0, "utf-32")
      params = vim.tbl_extend("force", params, {
        context = { only = { "source.organizeImports" } }
      })

      vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx, _)
        if err then
          vim.notify("Error organizing imports: " .. err.message, vim.log.levels.ERROR)
          return
        end

        if result and #result > 0 then
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          local enc = client and client.offset_encoding or "utf-16"

          -- Apply the first code action with edits (organize imports)
          for _, action in ipairs(result) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, enc)
            end
          end
        end

        -- Format the buffer after organizing imports
        vim.lsp.buf.format({ async = false })
      end)
    end, { buffer = bufnr, desc = "Go organize imports and format" })
  end,

  templ = function(bufnr)
    vim.keymap.set("n", "<leader>f", templ_format, { buffer = bufnr, desc = "Templ format" })
  end,

  lua_ls = function(_)
    local love2d = require("love2d")
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Init Love2D LSP",
      callback = function()
        love2d.setup({
          path_to_love_bin = "love",
          path_to_love_library = vim.fn.globpath(vim.o.runtimepath, "love2d/library"),
          restart_on_save = false,
        })
      end
    })
  end
}

-- Setup each LSP server using the new API
for server_name, server_config in pairs(servers) do
  local config = {
    name = server_name,
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Call your common on_attach function
      if on_attach then
        on_attach(client, bufnr)
      end

      -- Add server-specific configurations
      local specific_config = server_specific_configs[server_name]
      if specific_config then
        specific_config(bufnr)
      end
    end,
    settings = server_config,
    filetypes = server_config.filetypes,
  }


  -- require('lspconfig')[server_name].setup(config)
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

-- Ensure the servers above are installed
require('mason-lspconfig').setup({
  ensure_installed = vim.tbl_keys(servers)
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
luasnip.config.set_config { history = false, updateevents = 'TextChanged,TextChangedI' }
-- require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp', max_item_count = 30 },
    { name = 'path' },
    { name = 'buffer' },
  },
}

cmp.setup.filetype({ "sql", "mysql" }, {
  sources = {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.script",
  callback = function()
    vim.bo.filetype = "lua"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end
      })
    end
  end
})
