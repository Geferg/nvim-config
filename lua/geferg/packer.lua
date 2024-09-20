-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'navarasu/onedark.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'nvim-treesitter/playground'

    use 'nvim-lua/plenary.nvim'
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},

            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'}
        }
    }

    --use 'cdelledonne/vim-cmake'

    use 'christoomey/vim-tmux-navigator'

    use 'nvim-tree/nvim-web-devicons'

    use 'prichrd/netrw.nvim'

    use 'folke/which-key.nvim'

    use 'ThePrimeagen/vim-be-good'

    use {
        'folke/todo-comments.nvim',
        requires = {{'nvim-lua/plenary.nvim'}},
    }

    use 'wakatime/vim-wakatime'

end)


