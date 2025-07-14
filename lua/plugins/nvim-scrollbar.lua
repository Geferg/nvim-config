return {
    {
        "petertriho/nvim-scrollbar",
        event = "VeryLazy",
        config = function()
            require("scrollbar").setup({
                show = true,
                handlers = {
                    gitsigns = true,
                    search = true,
                },
                marks = {
                    GitAdd = { text = "▁" },
                    GitChange = { text = "▁" },
                    GitDelete = { text = "▁" },
                },

                excluded_buftypes = {
                    "terminal",
                    "nofile",
                    "prompt",
                },
                excluded_filetypes = {
                    "neo-tree",
                    "blink-cmp-menu",
                    "dropbar_menu",
                    "dropbar_menu_fzf",
                    "DressingInput",
                    "cmp_docs",
                    "cmp_menu",
                    "noice",
                    "prompt",
                    "TelescopePrompt",
                },
            })
        end
    }
}
