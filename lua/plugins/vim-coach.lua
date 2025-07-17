return {
    {
        "shahshlok/vim-coach.nvim",
        dependencies = {
            "folke/snacks.nvim",
        },

        init = function()
            vim.g.vim_coach_no_default_keymaps = 1
        end,

        -- WARNING: Uses bad lazy spec
        config = function()
            require("vim-coach").setup()
        end,
    }
}
