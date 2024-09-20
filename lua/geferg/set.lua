vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.g.netrw_liststyle = 0
vim.g.netrw_bufsettings = 'noma nomod nobl nowrap ro rnu nonu'

require("nvim-web-devicons").setup()

require("netrw").setup({
    use_devicons = true
})

vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = "C:/Users/krist/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"

vim.opt.backspace = "indent,eol,start"

vim.opt.clipboard:append("unnamedplus")

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

--vim.opt.colorcolumn = "80"

vim.g.mapleader = " "


