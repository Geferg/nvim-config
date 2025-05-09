vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.g.netrw_liststyle = 0
vim.g.netrw_bufsettings = "noma nomod nobl nowrap ro"
vim.g.netrw_banner = 0

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

vim.opt.clipboard:append("unnamedplus")

vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

vim.opt.signcolumn = "yes"
vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.showcmd = true

vim.opt.colorcolumn = "80"

vim.opt.updatetime = 250
