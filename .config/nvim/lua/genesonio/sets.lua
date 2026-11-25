vim.o.nu = true
vim.opt.relativenumber = true

vim.g.have_nerd_font = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- Neovim's Go ftplugin forces tabs (noexpandtab, ts=4); keep our spaces instead
vim.g.go_recommended_style = 0
-- vim.opt.colorcolumn = "90"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")


vim.opt.updatetime = 150

-- Defold scripts are Lua
vim.filetype.add({ extension = { script = "lua" } })

vim.o.signcolumn = "yes"

vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true

vim.o.cmdheight = 1

-- append to the defaults (internal,filler,closeoff,linematch:40) instead of replacing them
vim.opt.diffopt:append({ "iblank", "vertical" })

--------------
--- MACROS ---
--------------

local ctrlA = vim.api.nvim_replace_termcodes("<C-A>", true, true, true)
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

vim.fn.setreg("l", "p" .. ctrlA .. "yy")

vim.api.nvim_create_augroup("JSLogMacro", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "JSLogMacro",
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.fn.setreg("j", 'oconsole.log("' .. esc .. 'pa:",' .. esc .. "pa);" .. esc)
  end
})
