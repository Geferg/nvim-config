return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        dependencies = { "OXY2DEV/markview.nvim" },
        opts = {
            ensure_installed = {
                "lua",
                "markdown",
                "markdown_inline",
                "vim",
                "bash",
                -- Add languages here
            },

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
            },
        },
    },
}
