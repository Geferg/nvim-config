return {
    {
        "folke/which-key.nvim",
        lazy = false,
        event = "VeryLazy",
        opts = {
            triggers_nowait = {
                "<leader>",
            },

            disable = {
                buftypes = {},
                filetypes = {},
            },
        },
        config = function()
            local wk = require("which-key")
            local keybindings = require("features.keybindings")

            wk.add(keybindings, { mode = "n" })
        end,
    },
}
