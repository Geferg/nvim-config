return {
    {
        "shahshlok/vim-coach.nvim",
        dependencies = {
            "folke/snacks.nvim",
        },

        init = function()
            vim.g.vim_coach_no_default_keymaps = 1
        end,

        config = function()
            require("vim-coach").setup()
        end,
    }
}
