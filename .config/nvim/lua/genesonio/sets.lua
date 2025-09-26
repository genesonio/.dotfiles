vim.o.nu = true
vim.opt.relativenumber = true

vim.g.have_nerd_font = true

vim.opt.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.colorcolumn = "90"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")


vim.opt.updatetime = 50

vim.o.signcolumn = "yes"

vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true

vim.o.cmdheight = 1

vim.opt.diffopt = "iblank,vertical,internal"

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
