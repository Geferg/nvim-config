return {
    {
        "echasnovski/mini.animate",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.animate").setup({
                cursor = {
                    enable = true,
                    timing = require("mini.animate").gen_timing.linear({ duration = 70, unit = "total" }),
                },
                scroll = {
                    enable = true,
                    timing = require("mini.animate").gen_timing.linear({ duration = 150, unit = "total" }),
                },
                resize = {
                    enable = true,
                    timing = require("mini.animate").gen_timing.linear({ duration = 120, unit = "total" }),
                },
                open = { enable = false }, -- Optional: don't animate splits/popups
                close = { enable = false },
            })
        end,
    },
}
